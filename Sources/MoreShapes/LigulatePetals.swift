//
//  LigulatePetals.swift
//
//
//  Created by Chen Hai Teng on 3/4/24.
//

import SwiftUI
import CoreGraphicsExtension

public struct LigulatePetals: Shape {
    let petalCount: Int
    let insets: EdgeInsets
    let diskRatio: Double
    let petalRatio: Double
    let fixedPetalWidth: Double?
    
    private func petal(length: Double, width: Double, diskRadius: Double) -> Path {
        Path { p in
            let root = CGPoint(x: 0.0, y: -diskRadius)
            let leftControlPt = root.offset(dx:-width/2.0, dy: -length*(1.0 - petalRatio))
            let rightControlPt = root.offset(dx:width/2.0, dy:-length*(1.0 - petalRatio))
            p.move(to: root)
            p.addQuadCurve(to: root.offset(dy: -length), control: leftControlPt)
            p.addQuadCurve(to: root, control: rightControlPt)
        }
    }
    
    public func path(in rect: CGRect) -> Path {
        let drawingRect = rect.inset(by: insets.uiEdgeInsets).fitSquare()
        let offsetT = CGAffineTransform(translationX: drawingRect.midX, y: drawingRect.midY)
        let petalLength = drawingRect.height * (1.0 - diskRatio)/2.0
        let diskRadius = diskRatio*drawingRect.height/2.0
        let petalWidth = fixedPetalWidth ?? min((diskRadius + petalLength)*Double.pi*2.0/Double(petalCount), petalLength/2.0)
        return Path { p in
            for i in 0..<petalCount {
                p.addPath(petal(length: petalLength, width: petalWidth, diskRadius: diskRadius), transform: offsetT.concatenating(.rotateTransform(around: drawingRect.center, by: CGAngle.pi*2.0*CGAngle(i)/CGAngle(petalCount))))
            }
        }
    }
    
    @available(*, deprecated, renamed: "init(petalCount:petalRatio:diskRatio:insets:fixedPetalWidth:)")
    public init(petalCount: Int, petalRatio: Double, diskRatio: Double, uiInsets: UIEdgeInsets, fixedPetalWidth:Double) {
        self.init(petalCount: petalCount, petalRatio: petalRatio, diskRatio: diskRatio, insets: uiInsets.edgeInsets, fixedPetalWidth: fixedPetalWidth)
    }
    
    public init(petalCount: Int = 8, petalRatio: Double = 0.0, diskRatio: Double = 0.2, insets: EdgeInsets = .init(), fixedPetalWidth:Double = 0.0) {
        self.petalCount = petalCount
        self.insets = insets
        self.petalRatio = petalRatio
        self.diskRatio = diskRatio
        self.fixedPetalWidth = fixedPetalWidth > 0.0 ? fixedPetalWidth : nil
    }
}

extension LigulatePetals: InsettableShape {
    public func inset(by amount: CGFloat) -> some InsettableShape {
        LigulatePetals(petalCount: petalCount, petalRatio: petalRatio, diskRatio: diskRatio, insets: insets.inset(by: amount))
    }
}

#Preview {
    VStack {
        LigulatePetals()
        ZStack {
            LigulatePetals().stroke(Color.gray, lineWidth: 5.0)
            LigulatePetals().inset(by:50.0).stroke(AngularGradient {
                Color.red
                Color.blue
                Color.yellow
            }, lineWidth: 8.0).rotationEffect(Angle(degrees: 22.5))
        }
    }
}
