//
//  UIView+IBInspectable.swift
//  L Calc
//
//  Created by Igor Malyarov on 23.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
