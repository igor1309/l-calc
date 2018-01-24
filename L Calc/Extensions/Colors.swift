//
//  Colors.swift
//  L Calc
//
//  Created by Igor Malyarov on 08.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

extension UIColor {
    static let iron = UIColor(
        red: 0.370555,
        green: 0.370565,
        blue: 0.37056,
        alpha: 1.0)
    //  https://gist.github.com/haggen/c91ed87700e5971f6fc6
    static let silver = UIColor(    //  silver: rgb(208, 208, 208)
        red: 208 / 255.0,
        green: 208 / 255.0,
        blue: 208 / 255.0,
        alpha: 1.0)
    static let mercury = UIColor(   //  mercury: rgb(232, 232, 232)
        red: 232 / 255.0,
        green: 232 / 255.0,
        blue: 232 / 255.0,
        alpha: 1.0)
    static let darkGreen = UIColor(   // custom dark green: rgb(0, 107, 108)
        red: 0,
        green: 107 / 255.0,
        blue: 108 / 255.0,
        alpha: 1.0)
    static let veryLightGrey = UIColor(
        red: 250 / 255.0,
        green: 250 / 255.0,
        blue: 250 / 255.0,
        alpha: 1.0)
}


// https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values#answer-24263296
//
// Usage:

// let color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
// let color2 = UIColor(rgb: 0xFFFFFF)

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
