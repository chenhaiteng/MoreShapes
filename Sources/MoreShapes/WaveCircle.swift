//
//  SwiftUIView.swift
//  MoreShapes
//
//  Created by Chen Hai Teng on 3/3/24.
//

import SwiftUI
import Accelerate
import CoreGraphicsExtension
import GradientBuilder

public struct WaveCircle: Shape {
    private let amplitudes: [Double]
    private let amplitude: Double
    private let waves: Int
    private let insets: EdgeInsets
    
    public func path(in rect: CGRect) -> Path {
        let drawingRect = rect.inset(by: insets.uiEdgeInsets).fitSquare()
        return Path { p in
            let baseDegree = waves%2 == 0 ? CGAngle.degrees(360.0/Double(waves)/4.0) : CGAngle.degrees(360.0/Double(waves)/2.0)
            let r = drawingRect.width/2.0 - amplitude
            let startPt = CGPolarPoint(radius: r, angle: .zero + baseDegree).cgpoint.offset(dx:drawingRect.midX, dy: drawingRect.midY)
            p.move(to: startPt)
            var x = 0.0
            let stepRadian = 2.0 * Double.pi/Double(waves)/4.0
            for i in stride(from: 1, to: amplitudes.count, by: 2) {
                x += stepRadian * 2.0
                let nextPolarPt = CGPolarPoint(radius: r, angle: CGAngle.radians(x) + baseDegree).cgpoint.offset(dx:drawingRect.midX, dy:drawingRect.midY)
                let control1 = CGPolarPoint(radius: r + amplitudes[i], angle: CGAngle.radians(x - stepRadian) + baseDegree).cgpoint.offset(dx:drawingRect.midX, dy: drawingRect.midY)
                let control2 = CGPolarPoint(radius: r + amplitudes[i+1], angle: CGAngle.radians(x) + baseDegree).cgpoint.offset(dx:drawingRect.midX, dy: drawingRect.midY)
                p.addCurve(to: nextPolarPt, control1: control1, control2: control2)
            }
        }
    }
    
    @available(*, deprecated, renamed: "init(_:waves:insets:)")
    public init<T: BinaryFloatingPoint>(_ amplitude: T, waves: Int, uiInsets: UIEdgeInsets) {
        self.init(amplitude, waves: waves, insets: uiInsets.edgeInsets)
    }
    
    public init<T: BinaryFloatingPoint>(_ amplitude: T = Double(2.0), waves: Int = 12, insets: EdgeInsets = .init()) {
        self.insets = insets
        guard amplitude > 0, waves > 0 else {
            amplitudes = []
            self.amplitude = 0.0
            self.waves = 0
            return
        }
        var x: [Double] = [Double](repeating:0, count: waves*4+1)
        for i in 0..<x.count {
            x[i] = Double(i)*0.5
        }
        var y = [Double](repeating: 0, count: x.count)
        var n = Int32(x.count)
        vvsinpi(&y, &x, &n)
        amplitudes = y.map({ value in
            value*Double(amplitude)*Double.pi
        })
        self.amplitude = Double(amplitude)
        self.waves = waves
    }
}

extension WaveCircle: InsettableShape {
    public func inset(by amount: CGFloat) -> WaveCircle {
        return WaveCircle(self.amplitude, waves: self.waves, insets: insets.inset(by: amount))
    }
}

