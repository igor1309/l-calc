import Foundation

let amount = 5.4 * 1000 * 1000
let rate = 9.4
let term = 120.0 // 60.0
let precision = 0.00001 // 1e-10

var a = [Int]()
var b = [Int]()
let r = rate / 100 / 12 // monthly interest rate

// fixed principal
let principal = amount / term
for i in 1...Int(term) {
    let beginningBalance = amount * (1 - Double (i - 1) / term)
    let interest = beginningBalance * r
    a.append(Int(principal + interest))
    b.append(Int(interest))
}

a = [Int]()
b = [Int]()

// аннуитет = fixed monthly payment
let monthlyPayment = amount /
    ((1 - pow(1 + r, Double(0 - term))) / r)
for _ in 1...Int(term) {
    a.append(Int(monthlyPayment))
}

a = [Int]()
b = [Int]()

// interestOnly
let interest = amount * r
for _ in 1..<Int(term) {
    a.append(Int(interest))
}
a.append(Int(amount + interest))

print(a)
print(a.count)
print(b)

func f(x: Double) -> Double {
    var f: Double = 0
    for i in 1...a.count {
        let cf = Double(a[i - 1])
        let discount = pow(x, Double(i))
        f += cf * discount
    }
    return amount - f
}

func fd(x: Double) -> Double {
    var fd: Double = 0
    for i in 1...a.count {
        let k = Double(i)
        let cf = Double(a[i - 1])
        let discount = pow(x, Double(i))
        fd += k * cf * discount
    }
    return fd
}
var NPV: Double = amount
var xOld: Double = 1 / (1 + r)
var xNew: Double = 1 / (1 + r)

while fabs(NPV) >= precision {
    xOld = xNew
    xNew = xOld + f(x: xOld) / fd(x: xOld)
    NPV = f(x: xNew)
}
print(NPV)
print(xNew)
let j = 1 / xNew - 1
print(j * 100)
print((pow(1 + j, 12) - 1) * 100)

func IRR(_ loanAmount: Double, nominalRate: Double = 10, cashFlows: [Int]) -> Double {
    
    func f(x: Double) -> Double {
        var f: Double = 0
        for i in 1...a.count {
            let cf = Double(a[i - 1])
            let discount = pow(x, Double(i))
            f += cf * discount
        }
        return amount - f
    }
    
    func fd(x: Double) -> Double {
        var fd: Double = 0
        for i in 1...a.count {
            let k = Double(i)
            let cf = Double(a[i - 1])
            let discount = pow(x, Double(i))
            fd += k * cf * discount
        }
        return fd
    }
    
    var NPV: Double = amount
    let r = nominalRate / 100 / 12 // monthly interest rate

    var xOld: Double = 1 / (1 + r)
    var xNew: Double = 1 / (1 + r)
    
    while fabs(NPV) >= precision {
        xOld = xNew
        xNew = xOld + f(x: xOld) / fd(x: xOld)
        NPV = f(x: xNew)
    }

    let j = 1 / xNew - 1

    return (pow(1 + j, 12) - 1) * 100
}

print("IRR: \(IRR(amount, nominalRate: rate, cashFlows: a))")
