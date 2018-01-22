//
//  Loan.swift
//  L Calc
//
//  Created by Igor Malyarov on 10.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import Foundation

struct Loan {
    
    enum InterestType: String {
        case fixedFlat          = "Fixed"       //  в конце срока
        case decliningBalance   = "Annuity"     //  аннуитет
    }
    
    private let maxPrincipal = pow(10.0, 10.0)
    private let minPrincipal = 10000.0
    
    var amount: Double {     //  сумма кредита
        
        didSet {
            // контроль границ диапазона суммы кредита
            if amount > maxPrincipal {
                amount = maxPrincipal
                print("перебор")
            } else if amount < minPrincipal {
                amount = minPrincipal
                print("маловато")
            }
        }
        
        willSet {
            if amount != newValue {  // save if value changes
                UserDefaults.standard.set(amount, forKey: "Principal")
            }
        }
    }
    var rate: Double {    //  годовая процентная ставка
        willSet {
            if rate != newValue {  // save if value changes
                UserDefaults.standard.set(rate, forKey: "Rate")
            }
        }
    }

    var term: Double {    //  срок кредита в месяцах
        willSet {
            if term != newValue {  // save if value changes
                UserDefaults.standard.set(term, forKey: "Term")
            }
        }
    }

    var type: InterestType {   //  аннуитет
        willSet {
            if type != newValue {  // save if value changes
                UserDefaults.standard.set(type, forKey: "InterestType")
            }
        }
    }
    
    var monthlyPayment: Double {    // размер ежемесячного платежа
        let r = rate / 100 / 12    // monthly interest rate
        
        switch type {
        case .decliningBalance:
            //  аннуитет http://financeformulas.net/Annuity_Payment_Formula.html
            let p = pow(1 + r, 0 - term)
            return amount/((1 - p)/r)
        case .fixedFlat:
            return amount * r
        }
    }
    
    var totalInterest: Double {     // проценты за весь срок кредита
        let r = rate / 100 / 12    // monthly interest rate
        
        switch type {
        case .decliningBalance:
            let p = pow(1 + r, 0 - term)
            let mp = amount/((1 - p)/r)
            return mp * term - amount
        case .fixedFlat:
            return amount * r * term
        }
    }
    
    var totalPayments: Double {     // общий размер всех платежей, тело + проценты
        let r = rate / 100 / 12    // monthly interest rate
        
        switch type {
        case .decliningBalance:
            let p = pow(1 + r, 0 - term)
            let mp = amount/((1 - p)/r)
            return mp * term
        case .fixedFlat:
            return amount * (1 + r * term)
        }
    }
    
    
    init(
        _ principal: Double,
        _ rate: Double,
        _ term: Double,
        _ type: InterestType) {
        self.amount = principal
        self.rate = rate
        self.term = term
        self.type = type
    }
    
    init() {
        // MARK: + First Time handling
        let userDefaults = UserDefaults.standard
        let notFirstTime = userDefaults.bool(forKey: "NotFirstTime")
        
        if notFirstTime {
            amount = userDefaults.double(forKey: "Principal")
            rate = userDefaults.double(forKey: "Rate")
            term = userDefaults.double(forKey: "Term")
            // FIXME: read UserDefaults forKey: "AnnuitySegment"
            // FIXME: допилить: определить и использовать loan type as property of class
            type = .decliningBalance
        } else {
            self.amount = 5000000.0
            self.rate = 9.4
            self.term = 60.0
            self.type = .decliningBalance
            
            userDefaults.set(true, forKey: "NotFirstTime")
            userDefaults.synchronize()
        }
    }
    
}
