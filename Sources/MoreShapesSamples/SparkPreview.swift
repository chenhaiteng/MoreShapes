//
//  SparkPreview.swift
//  MoreShapes
//
//  Created by Chen Hai Teng on 10/3/24.
//

import SwiftUI
import MoreShapes

#Preview {
    VStack {
        Spark()
        ZStack {
            Spark(vertices: 20).inset(by: 30.0).stroke()
            Spark(vertices: 20).inset(by: 60.0).fill(RadialGradient {
                Color.white
                Color.yellow
                Color.red
            })
        }
    }
}

