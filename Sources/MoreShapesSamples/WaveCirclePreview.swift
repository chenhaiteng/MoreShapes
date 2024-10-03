//
//  WaveCirclePreview.swift
//  MoreShapes
//
//  Created by Chen Hai Teng on 10/3/24.
//

import SwiftUI
import MoreShapes

#Preview {
    VStack {
        WaveCircle()
        ZStack {
            WaveCircle(6.0)
            WaveCircle(6.0).inset(by: 30.0).stroke(AngularGradient({
                Color.red
                Color.yellow
                Color.blue
                Color.red
            }), lineWidth: 5.0)
        }
    }
}
