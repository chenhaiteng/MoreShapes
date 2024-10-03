//
//  Spark.swift
//  MoreShapes
//
//  Created by Chen Hai Teng on 3/3/24.
//

import SwiftUI
import CoreGraphicsExtension
import GradientBuilder

public struct Spark: Shape {
    let insets: EdgeInsets
    let depth: Double
    let vertices: Int
    
    public func path(in rect: CGRect) -> Path {
        let drawingRect = rect.inset(by: insets.uiEdgeInsets).fitSquare()
        let r = drawingRect.width/2.0
        let incrementAngle = CGAngle.degrees( 360.0/Double(vertices))
        let start = CGPolarPoint(radius: r, angle: .zero).cgpoint
        let controlPt = CGPolarPoint(radius: r*(1.0 - depth), angle: incrementAngle/2.0).cgpoint
        let toPt = CGPolarPoint(radius: r, angle: incrementAngle).cgpoint
        let offsetT = CGAffineTransform.init(translationX: drawingRect.midX, y: drawingRect.midY)
        return Path { p in
            p.move(to: start.applying(offsetT))
            for i in 0..<vertices {
                let transform = offsetT.concatenating(
                    .rotateTransform(around: drawingRect.center, by: incrementAngle * Double(i)))
                p.addQuadCurve(to: toPt.applying(transform), control: controlPt.applying(transform))
            }
        }
    }
    
    @available(*, deprecated, renamed: "init(vertices:depth:insets:)")
    public init(vertices: Int, depth: Double, uiInsets: UIEdgeInsets) {
        self.init(vertices: vertices, depth: depth, insets: uiInsets.edgeInsets)
    }
    
    public init(vertices: Int = 10, depth: Double = 0.8, insets: EdgeInsets = .init()) {
        self.vertices = vertices
        self.depth = depth
        self.insets = insets
    }
}

extension Spark : InsettableShape {
    public func inset(by amount: CGFloat) -> some InsettableShape {
        Spark(vertices: self.vertices, depth: self.depth, insets: self.insets.inset(by: amount))
    }
}
