import Foundation
import UIKit

var timer = 100

let change = 14

timer += change

timer = Int(round(Double(timer / 5)) * 5)

var graphPoints1: [Int] = [4, 7, 6, 8, 5, 9, 7, 8, 10, 8, 7, 10, 9, 6, 9, 7, 8, 6, 9, 8, 9, 5]
var graphPoints2: [Int] = [9, 11, 10, 13, 16, 12, 10, 15, 14, 12, 11, 15, 13, 16, 15, 14, 16, 14, 13, 15, 12, 13]

var graphPoints1s: [Int] = [4, 7, 6, 8, 5]
var graphPoints2s: [Int] = [9, 11, 10, 13, 16]

extension UIColor {
    convenience init(hexString: String){
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

typealias GraphOptions = [(
    lineColor: String, // hex string
    circleRadius: Int,
    gradientStartColor: String, // hex string
    gradientEndColor: String // hex string
    )]

var gOpt: GraphOptions

gOpt = [
    ("ce9ffc", 5, "ce9ffc", "ce9ffc")]

let i: Int = 0
let options = gOpt[i]
let lineColor1 = UIColor(hexString: options.lineColor)

let (lineColor, circleRadius, gradientStartColor, gradientEndColor) = gOpt[i]

