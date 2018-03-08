//: Playground - noun: a place where people can play

import Foundation

let number: Double = 78800
let plusMinus: Double = 1

let orderOfMagnitude = String(Int(number)).count - 1
let magnitude = Double(truncating: pow(10, orderOfMagnitude) as NSNumber)
var approx = (number / magnitude + plusMinus * 0.055) * 10
approx = approx.rounded()
approx = approx * magnitude / 10

