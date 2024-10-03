//
//  KilaWheel.swift
//
//
//  Created by Chen Hai Teng on 3/3/24.
//

import SwiftUI
import CoreGraphicsExtension
import GradientBuilder

public extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        if #available(iOS 17.0, *) {
            AnyView(self.stroke(strokeStyle, lineWidth: lineWidth).fill(fillStyle))
        } else {
            // Fallback on earlier versions
            AnyView(self
                .stroke(strokeStyle, lineWidth: lineWidth)
                .background(self.fill(fillStyle)))
        }
        
    }
}

public struct KilaWheel: Shape {
    let kilaHeight: Double
    let kilaWidth: Double
    let kilaCount: Int
    let kilaOffset: Double
    let insets: EdgeInsets
    
    public func path(in rect: CGRect) -> Path {
        guard !rect.isEmpty else { return Path() }
        let drawingRect = rect.inset(by: insets.uiEdgeInsets).fitSquare()
        let size = drawingRect.width
        let angleStep = Double.pi*2.0/Double(kilaCount)
        var path = Path()
        // Start
        let offsetT = CGAffineTransform(translationX: drawingRect.midX, y: drawingRect.midY)
        let r = (1.0 - kilaHeight) * size/2.0
        let startDegree: CGAngle = -Double.pi/2.0 - angleStep/2.0
        
        let startPt = CGPolarPoint(radius: r, angle: startDegree).cgpoint
        
        let endPt = CGPolarPoint(radius: r, angle: startDegree + angleStep).cgpoint
        let top = CGPolarPoint(radius: size/2.0, angle: -Double.pi/2.0).cgpoint
        let bottom = CGPolarPoint(radius: r, angle: -Double.pi/2.0).cgpoint.offset(dy:kilaOffset)
        
        let totalWidth = endPt.x - startPt.x
        let leftAnchor = CGPoint(x: startPt.x + totalWidth * (1.0 - kilaWidth)/2.0, y: bottom.y)
        let rightAnchor = CGPoint(x: endPt.x - totalWidth * (1.0 - kilaWidth)/2.0, y: bottom.y)
        
        let controlPt1X = (leftAnchor.x - startPt.x)/2.0 + totalWidth * 0.05
        let controlPt2X = (rightAnchor.x - endPt.x)/2.0 - totalWidth * 0.05
        let controlPtY = (startPt.y - leftAnchor.y)/2.0
        
        let leftControlPt = leftAnchor.applying(CGAffineTransform(translationX: controlPt1X, y: controlPtY))
        let rightControlPt = rightAnchor.applying(CGAffineTransform(translationX: controlPt2X, y: controlPtY))
        path.move(to: startPt.applying(offsetT))
        for i in 0..<kilaCount {
            let transform = offsetT.concatenating( CGAffineTransform.rotateTransform(around:drawingRect.center, by: angleStep*Double(i)))
            path.addQuadCurve(to: leftAnchor.applying(transform), control: leftControlPt.applying(transform))
            path.addLine(to: top.applying(transform))
            path.addLine(to: rightAnchor.applying(transform))
            path.addQuadCurve(to:endPt.applying(transform), control: rightControlPt.applying(transform))
        }
        return path
    }
    
    @available(*, deprecated, renamed: "init(kilaHeight:kilaWidth:kilaCount:kilaOffset:insets:)")
    public init(kilaHeight: Double, kilaWidth: Double, kilaCount: Int, kilaOffset:Double, uiInsets: UIEdgeInsets) {
        self.init(kilaHeight: kilaHeight, kilaWidth: kilaWidth, kilaCount: kilaCount, kilaOffset: kilaOffset, insets: uiInsets.edgeInsets)
    }
    
    public init(kilaHeight: Double = 0.15, kilaWidth: Double = 0.9, kilaCount: Int = 10, kilaOffset:Double = -5.0, insets: EdgeInsets = .init()) {
        self.kilaHeight = kilaHeight
        self.kilaWidth = kilaWidth
        self.kilaCount = kilaCount
        self.kilaOffset = kilaOffset
        self.insets = insets
    }
}

extension KilaWheel : InsettableShape {
    public func inset(by amount: CGFloat) -> some InsettableShape {
        KilaWheel(kilaHeight: kilaHeight, kilaWidth: kilaWidth, kilaCount: kilaCount, kilaOffset: kilaOffset, insets: insets.inset(by: amount))
    }
}
