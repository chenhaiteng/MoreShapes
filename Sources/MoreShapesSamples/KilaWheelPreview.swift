//
//  KilaWheelPreview.swift
//  MoreShapes
//
//  Created by Chen Hai Teng on 10/3/24.
//

import SwiftUI
import MoreShapes

struct KilaCanvas : View {
    var body: some View {
        Canvas { context, size in
            context.fill(KilaWheel().path(in: CGRect(origin: .zero, size: size)), with: .radialGradient(Gradient {
                Color.white
                Color.blue
            }, center: CGPoint(x: size.width/2.0, y: size.height/2.0), startRadius: 0.0, endRadius: 300.0))
        }
    }
}

#Preview {
    KilaCanvas()
    VStack {
        KilaWheel()
        KilaWheel(insets:.init(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 40.0)).fill(RadialGradient(center: .center, startRadius: 0.0, endRadius: 300.0) {
            Color.white
            Color.blue
        }, strokeBorder: .gray, lineWidth: 5.0)
    }
}
