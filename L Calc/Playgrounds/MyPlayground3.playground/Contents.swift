//: Playground - noun: a place where people can play

import Foundation

enum Direction { case up, down }

func changeNumber (_ number: Double, direction: Direction) -> Double {
    
    var plusMinus: Double
    
    switch direction {
    case .up: plusMinus = 1
    default: plusMinus = -1
    }
    
    let orderOfMagnitude = String(Int(number)).count - 1
    let magnitude = Double(truncating: pow(10, orderOfMagnitude) as NSNumber)
    var approx = (number / magnitude + plusMinus * 0.055) * 10
    approx = approx.rounded()
    approx = approx * magnitude / 10
    return approx
}

let number: Double = 55000088
print(changeNumber(number, direction: .down))
print(changeNumber(number, direction: .up))


