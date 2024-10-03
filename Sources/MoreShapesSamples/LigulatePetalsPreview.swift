//
//  LigulatePetalsPreview.swift
//  MoreShapes
//
//  Created by Chen Hai Teng on 10/4/24.
//

import SwiftUI
import MoreShapes


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
