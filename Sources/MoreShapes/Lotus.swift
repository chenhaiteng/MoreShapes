//
//  Lotus.swift
//  MoreShapes
//
//  Created by Chen Hai Teng on 10/27/23.
//

import SwiftUI
import CoreGraphicsExtension

public struct Lotus: Shape {
    var radius: CGFloat
    var petalDepth: CGFloat
    var petalCount: Int
    let lotusDegrees: CGFloat
    let ratioX: CGFloat
    let ratioY: CGFloat
    let curvature: CGFloat
    
    private func petal(_ center: CGPoint) -> Path {
        Path { p in
            let innerRadius = radius - petalDepth
            let startPt = CGPolarPoint(radius: innerRadius, angle: .degrees(-90.0 - 360.0/Double(petalCount*2))).cgpoint
            let endPt = CGPolarPoint(radius: innerRadius, angle: .degrees(-90.0 + 360.0/Double(petalCount*2))).cgpoint
            let top = CGPolarPoint(radius: radius, angle: .degrees(-90.0)).cgpoint
            let controlPt1 = CGPoint(x: startPt.x - (top.x - startPt.x)*ratioX, y: startPt.y - (startPt.y - top.y)*ratioY)
            let controlPt2 = CGPoint(x: top.x, y: top.y + (startPt.y - top.y)*curvature)
            let controlPt3 = CGPoint(x: endPt.x + (endPt.x - top.x)*ratioX, y: endPt.y - (endPt.y - top.y)*ratioY)
            p.addCurve(to: top, control1: controlPt1, control2: controlPt2)
            p.addCurve(to: endPt, control1: controlPt2, control2: controlPt3)
        }
    }
    
    private func petals(_ center: CGPoint) -> Path {
        let innerRadius = radius - petalDepth
        let startPt = CGPolarPoint(radius: innerRadius, angle: .degrees(-90.0 - 360.0/Double(petalCount*2))).cgpoint.offset(dx: center.x, dy: center.y)
        var path = Path()
        path.move(to: startPt)
        for i in 0..<petalCount {
            let transform =
            CGAffineTransform(translationX: center.x, y: center.y).concatenating( CGAffineTransform.rotateTransform(around:center, by: CGAngle.degrees(Double(i)*360.0/Double(petalCount))))
            path.addPath(petal(center), transform: transform)
        }
        return path
    }
    
    public func path(in rect: CGRect) -> Path {
        guard !rect.isEmpty else { return Path() }
        guard radius > petalDepth else { return Path() }
        guard radius < rect.width, radius < rect.height else  {return Path()}
        
        return petals(rect.center)
    }
    
    public init(radius: CGFloat = 100.0, petalDepth: CGFloat = 50.0, petalCount: Int = 6, degrees: CGFloat = 0.0, petalRatio: UnitPoint = .init(x: 0.9, y: 0.8), curvature: CGFloat = 0.3) {
        self.radius = radius
        self.petalDepth = petalDepth
        self.petalCount = petalCount
        self.lotusDegrees = degrees
        
        ratioX = petalRatio.x
        ratioY = petalRatio.y
        self.curvature = curvature
    }
}

#Preview {
    Lotus(radius: 200.0, petalDepth: 80.0, petalCount: 18).stroke()
}
