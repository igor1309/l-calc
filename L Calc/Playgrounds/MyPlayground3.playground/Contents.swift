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

let number: Double = 1888999
print(changeNumber(number, direction: .down))
//print(changeNumber(number, direction: .up))

func changeNumber (_ number: Double, direction: Direction, useDecimal: Bool) -> Double {
    
    var plusMinus: Double
    
    switch direction {
    case .up: plusMinus = 1
    default: plusMinus = -1
    }
    
    if useDecimal {
        var approx = (number * 10 + plusMinus)
        approx = approx.rounded()
        approx = approx / 10
        return approx
    } else {
        return changeNumber(number, direction: direction)
    }
}

let n: Double = 17.6
print("\(n) ↙ \(changeNumber(n, direction: .down, useDecimal: true))")
print("\(n) ↗ \(changeNumber(n, direction: .up, useDecimal: true))")


