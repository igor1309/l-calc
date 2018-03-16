//
//  Loan.swift
//  L Calc
//
//  Created by Igor Malyarov on 10.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
//  https://financial-calculators.com/fixed-principal-payment-calculator

import UIKit

enum InterestType: String {
    case interestOnly   = "interestOnly"    //  в конце срока
    case fixedPrincipal = "fixedPrincipal"  //  тело равными частями
    case fixedPayment   = "fixedPayment"    //  аннуитет
}

struct Loan {
    
    private let maxPrincipal = pow(10.0, 10.0)
    private let minPrincipal = 10000.0
    private let maxRate = 100.0
    private let minRate = 0.1
    private let maxTerm = 180.0
    private let minTerm = 2.0
    
    let interestTypeName: [InterestType: String] = [
        .interestOnly: "В КОНЦЕ",
        .fixedPrincipal: "РАВНЫМИ",
        .fixedPayment: "АННУИТЕТ"
    ]
    
    let interestTypeComment: [InterestType: String] = [
        .interestOnly: "Проценты выплачиваются ежемесячно, а тело кредита – в конце срока",
        .fixedPrincipal: "Тело кредита погашается ежемесячно равными суммами",
        .fixedPayment: "Ежемесячные выплаты равными суммами, включающими проценты и тело кредита"
    ]
    
    var amount: Double {     //  сумма кредита
        didSet {
            // контроль границ диапазона суммы кредита + notify
            let notification = NotificationCenter.default

            if amount > maxPrincipal {
                amount = maxPrincipal
                notification.post(Notification(name: .outOfRange))
                
            } else if amount < minPrincipal {
                amount = minPrincipal
                notification.post(Notification(name: .outOfRange))
            }
            UserDefaults.standard.set(amount,
                                      forKey: "Principal")
        }
    }
    var rate: Double {    //  годовая процентная ставка
        didSet {
            // контроль границ диапазона суммы кредита + notify
            let notification = NotificationCenter.default
            
            if rate > maxRate {
                rate = maxRate
                notification.post(Notification(name: .outOfRange))
                
            } else if rate < minRate {
                rate = minRate
                notification.post(Notification(name: .outOfRange))
            }
            UserDefaults.standard.set(rate,
                                      forKey: "Rate")
        }
    }

    var term: Double {    //  срок кредита в месяцах
        didSet {
            // контроль границ диапазона суммы кредита + notify
            let notification = NotificationCenter.default
            
            if term > maxTerm {
                term = maxTerm
                notification.post(Notification(name: .outOfRange))
                
            } else if term < minTerm {
                term = minTerm
                notification.post(Notification(name: .outOfRange))
            }
            UserDefaults.standard.set(term,
                                      forKey: "Term")
        }
    }
    
    var type: InterestType {   //  аннуитет
        willSet {
        // FIXME: вернуть запись данных только если значение изменилось
            UserDefaults.standard.set(newValue.rawValue,
                                      forKey: "InterestType")
        }
    }
}

extension Loan {
    
    var firstInterest: Double { // проценты в первом платеже
        let r = rate / 100 / 12    // monthly interest rate
        return amount * r
    }
    
    var firstPrincipal: Double { // тело в первом платеже
        let r = rate / 100 / 12    // monthly interest rate
        
        switch type {
        case .interestOnly:
            return 0
            
        case .fixedPayment:
            let p = pow(1 + r, 0 - term)
            return amount/((1 - p)/r) - amount * r
            
        case .fixedPrincipal:
            return amount / term
        }
    }
    
    var effectiveRate: Double {
        
        return irr(amount,
                   nominalRate: rate,
                   cashFlows: loanPaymentsMonthlyTotal())
    }

    var monthlyPayment: Double {    // размер ежемесячного платежа
        let r = rate / 100 / 12    // monthly interest rate
        
        switch type {
        case .interestOnly:     // все кроме последнего
            return amount * r
            
        case .fixedPayment:     // equal payments
            //  аннуитет http://financeformulas.net/Annuity_Payment_Formula.html
            let p = pow(1 + r, 0 - term)
            return amount/((1 - p)/r)
            
        case .fixedPrincipal:   // только первый платеж
            let interest = amount * r
            let principal = amount / term
            return principal + interest
        }
    }
    
    var totalInterest: Double {     // проценты за весь срок кредита
        let r = rate / 100 / 12    // monthly interest rate
        
        switch type {
        case .interestOnly:
            return amount * r * term

        case .fixedPayment:
            let p = pow(1 + r, 0 - term)
            let mp = amount/((1 - p)/r)
            return mp * term - amount
        
        case .fixedPrincipal:
            var totalInterest = 0.0
            for i in 1...Int(term) {
                let beginningBalance =
                    amount * (1 - Double (i - 1) / term)
                let interest = beginningBalance * r
                totalInterest += interest
            }
            return totalInterest
        }
    }
    
    var totalPayments: Double {     // общий размер всех платежей, тело + проценты
        let r = rate / 100 / 12    // monthly interest rate
        
        switch type {
        case .interestOnly:
            return amount * (1 + r * term)

        case .fixedPayment:
            let p = pow(1 + r, 0 - term)
            let mp = amount/((1 - p)/r)
            return mp * term
        
        case .fixedPrincipal:
            var totalInterest = 0.0
            for i in 1...Int(term) {
                let beginningBalance =
                    amount * (1 - Double (i - 1) / term)
                let interest = beginningBalance * r
                totalInterest += interest
            }
            return amount + totalInterest
        }
    }
    
    
    //MARK: - inits

    init() {    // init + First Time handling
        let userDefaults = UserDefaults.standard
        
        amount = userDefaults.double(forKey: "Principal")
        rate = userDefaults.double(forKey: "Rate")
        term = userDefaults.double(forKey: "Term")

        // handle First Time! or Crash
        if amount == 0 {
            amount = 5000000.0
        }
        if rate == 0 {
            rate = 9.4
        }
        if term == 0 {
            term = 60.0
        }
        
        type = .fixedPayment
        if let savedType = userDefaults.string(
            forKey: "InterestType") {
            switch savedType {
            case "interestOnly":
                type = .interestOnly
            case "fixedPrincipal":
                type = .fixedPrincipal
            case "fixedPayment":
                type = .fixedPayment
            default:
                type = .fixedPayment
            }
        }
    }
    
    init(
        _ amount: Double,
        _ rate: Double,
        _ term: Double,
        _ type: InterestType) {
        self.amount = amount
        self.rate = rate
        self.term = term
        self.type = type
    }
}

extension Loan {
    
    func irr(_ loanAmount: Double,
             nominalRate: Double = 10,
             cashFlows: [Int]) -> Double {
        
        let precision = 0.00001 // 1e-10

        
        func f(x: Double) -> Double {
            var f: Double = 0
            for i in 1...cashFlows.count {
                let cf = Double(cashFlows[i - 1])
                let discount = pow(x, Double(i))
                f += cf * discount
            }
            return amount - f
        }
        
        func fd(x: Double) -> Double {
            var fd: Double = 0
            for i in 1...cashFlows.count {
                let k = Double(i)
                let cf = Double(cashFlows[i - 1])
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
    
    func loanPaymentsMonthlyTotal() -> [Int] {
        
        let r = rate / 100 / 12    // monthly interest rate
        var a = [Int]()
        
        switch type {
        case .interestOnly:
            let interest = amount * r
            for _ in 1..<Int(term) {
                a.append(Int(interest))
            }
            a.append(Int(amount + interest))
            
        case .fixedPrincipal:
            let principal = amount / term
            for i in 1...Int(term) {
                let beginningBalance =
                    amount * (1 - Double (i - 1) / term)
                let interest = beginningBalance * r
                a.append(Int(principal + interest))
            }
        case .fixedPayment:    // аннуитет = fixed monthly payment
            let monthlyPayment = amount /
                ((1 - pow(1 + r, Double(0 - term))) / r)
            for _ in 1...Int(term) {
                a.append(Int(monthlyPayment))
            }
        }
        return a
    }
    
    func loanPaymentsMonthlyInterest() -> [Int] {
        let r = rate / 100 / 12    // monthly interest rate
        var a = [Int]()
        
        switch type {
        case .interestOnly:
            let interest = amount * r
            for _ in 1...Int(term) {
                a.append(Int(interest))
            }

        case .fixedPrincipal:
            for i in 1...Int(term) {
                let beginningBalance =
                    amount * (1 - Double (i - 1) / term)
                let interest = beginningBalance * r

                a.append(Int(interest))
            }
            
        case .fixedPayment:    // аннуитет w/fixed monthly payment
            let monthlyPayment = amount /
                ((1 - pow(1 + r, Double(0 - term))) / r)
            for i in 1...Int(term) {
                let beginningBalance =
                    amount * pow(1 + r, Double (i - 1)) -
                        monthlyPayment / r * (pow(1 + r, Double (i - 1)) - 1)
                let endingBalance =
                    amount * pow(1 + r, Double (i)) -
                        monthlyPayment / r * (pow(1 + r, Double (i)) - 1)
                let principal =
                    beginningBalance - endingBalance
                let interest =
                    monthlyPayment - principal

                a.append(Int(interest))
            }
        }
        return a

    }
    
    func loanPaymentsMonthlyPrincipal() -> [Int] {
        
        let r = rate / 100 / 12    // monthly interest rate
        var a = [Int]()
        
        switch type {
        case .interestOnly:
            for _ in 1..<Int(term) {
                a.append(0)
            }
            a.append(Int(amount))
            
        case .fixedPrincipal:
            let principal = amount / term
            for _ in 1...Int(term) {
                a.append(Int(principal))
            }
            
        case .fixedPayment:    // аннуитет w/fixed monthly payment
            let monthlyPayment = amount /
                ((1 - pow(1 + r, Double(0 - term))) / r)
            for i in 1...Int(term) {
                let beginningBalance =
                    amount * pow(1 + r, Double (i - 1)) -
                        monthlyPayment / r * (pow(1 + r, Double (i - 1)) - 1)
                let endingBalance =
                    amount * pow(1 + r, Double (i)) -
                        monthlyPayment / r * (pow(1 + r, Double (i)) - 1)
                let principal =
                    beginningBalance - endingBalance
                
                a.append(Int(principal))
            }
        }
        return a
    }
}

