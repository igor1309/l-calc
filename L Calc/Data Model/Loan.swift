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
    
    let interestTypeComment: [InterestType: String] = [
        .interestOnly: "Проценты выплачиваются ежемесячно, а тело кредита – в конце срока",
        .fixedPrincipal: "Тело кредита погашается ежемесячно равными суммами",
        .fixedPayment: "Ежемесячные выплаты равными суммами, включающими проценты и тело кредита"
    ]
    
    var amount: Double {     //  сумма кредита
        
        didSet {
            // контроль границ диапазона суммы кредита + notify
            let notification =
                NotificationCenter.default

            if amount > maxPrincipal {
                amount = maxPrincipal
                notification.post(
                    Notification(name: .outOfRange))
                
            } else if amount < minPrincipal {
                amount = minPrincipal
                notification.post(
                    Notification(name: .outOfRange))
            }
        }
        
        willSet {
        // FIXME: вернуть запись данных только если значение изменилось
            UserDefaults.standard.set(newValue,
                                      forKey: "Principal")
        }
    }
    var rate: Double {    //  годовая процентная ставка
        // FIXME: по аналогии с amount сделать с didSet контроль границ, особенно нижней, 0.01%
        // FIXME: add UINotificationFeedbackGenerator
        willSet {
        // FIXME: вернуть запись данных только если значение изменилось
            UserDefaults.standard.set(newValue,
                                      forKey: "Rate")
        }
    }

    var term: Double {    //  срок кредита в месяцах
        // FIXME: по аналогии с amount сделать с didSet контроль границ, особенно нижней, 0.01%
        // FIXME: add UINotificationFeedbackGenerator

        willSet {
        // FIXME: вернуть запись данных только если значение изменилось
        // if term != newValue {  // save if value changes
            UserDefaults.standard.set(newValue,
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
    
    var effectiveRate: Double { // тело в первом платеже
//        let r = rate / 100 / 12    // monthly interest rate
        
        switch type {
        case .interestOnly:
            // https://www.wikihow.com/Calculate-Effective-Interest-Rate
//            r = (1 + i/n)^n - 1.
//            In this formula, r represents the effective interest rate, i represents the stated interest rate, and n represents the number of compounding periods per year.
            let p = pow(1 + rate / 100 / 12, 12)
            return (p - 1) * 100
            
        case .fixedPayment:
            return 11
            
        case .fixedPrincipal:
            return 12
        }
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

