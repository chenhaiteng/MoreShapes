//
//  EdgeInsetsConversion.swift
//
//
//  Created by Chen Hai Teng on 3/3/24.
//

import Foundation
import SwiftUI

public extension EdgeInsets {
    func inset<T: BinaryFloatingPoint>(by amount:T) -> EdgeInsets {
        EdgeInsets(top: top + CGFloat(amount), leading: leading + CGFloat(amount), bottom: bottom + CGFloat(amount), trailing: trailing + CGFloat(amount))
    }
    
    var uiEdgeInsets : UIEdgeInsets {
        UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
    }
}

public extension UIEdgeInsets {
    func inset<T: BinaryFloatingPoint>(by amount:T) -> UIEdgeInsets {
        UIEdgeInsets(top: top + CGFloat(amount), left: self.left + CGFloat(amount), bottom: bottom + CGFloat(amount), right: self.right + CGFloat(amount))
    }
    
    var edgeInsets: EdgeInsets {
        EdgeInsets(top: self.top, leading: self.left, bottom: self.bottom, trailing: self.right)
    }
}
