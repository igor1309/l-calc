//: Playground - noun: a place where people can play

import Foundation

let amount = 5.4 * 1000 * 1000
let rate = 9.4
let term = 60.0

var a = [Int]()
let r = rate / 100 / 12    // monthly interest rate

// fixed principal
let principal = amount / term
for i in 1...Int(term) {
    let beginningBalance =
        amount * (1 - Double (i - 1) / term)
    let interest = beginningBalance * r
    a.append(Int(principal + interest))
}
//print(a)

var npv: Double = 0
var b = [Int]()

let dif: Double = 1.0
let effMonthlyRate = r
for i in 1...Int(term) {
    let v = pow(1 + effMonthlyRate, Double(-i))  // дисконт для периода i
    npv += Double(a[i-1]) * v
    let pl: Double = amount * r / (1 - pow(1 + r, -term))
    b.append(Int(pl))
}
print(npv)

for i in 1...Int(term) {
    print(a[i-1] - b[i-1])
}


print((pow(1 + rate / 100 / 12, 12) - 1) * 100)
