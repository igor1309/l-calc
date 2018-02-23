//
//  UIView+Gradient.swift
//  L Calc
//
//  Created by Igor Malyarov on 23.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
// https://mobikul.com/create-extension-gradient-swift-3-0/
// https://www.appcoda.com/cagradientlayer/

import UIKit

extension UIView {
    
    func applyGradient() -> Void {
        self.applyGradient(
            colors:[UIColor(rgb: 0x1D2C40),
                    UIColor(rgb: 0x364961)],
            locations: [0.0, 1.0])
    }
    
    func applyGradient(colors: [UIColor]) -> Void {
        self.applyGradient(colors: colors, locations: nil)
    }
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        
        gradient.colors = colors.map { $0.cgColor }
// add trsansparency
//        gradient.colors = colors.map { $0.withAlphaComponent(0.90).cgColor }

        gradient.locations = locations

        gradient.startPoint =
            CGPoint(x: 188/375, y: 154/812)
        gradient.endPoint =
            CGPoint(x: 1.0, y: 1.0)
        
        self.layer.addSublayer(gradient)
    }
}
