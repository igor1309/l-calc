//
//  Loan.swift
//  L Calc
//
//  Created by Igor Malyarov on 10.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

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
            let notification = UINotificationFeedbackGenerator()
            if amount > maxPrincipal {
                amount = maxPrincipal
                notification.notificationOccurred(.warning)
            } else if amount < minPrincipal {
                amount = minPrincipal
                notification.notificationOccurred(.warning)
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
    // MARK: inits

    init() {    // MARK: + First Time handling
        let userDefaults = UserDefaults.standard
        
        amount = userDefaults.double(forKey: "Principal")
        rate = userDefaults.double(forKey: "Rate")
        term = userDefaults.double(forKey: "Term")

        // MARK: handle First Time! or Crash
        if amount == 0 {
            amount = 5000000.0
        }
        if rate == 0 {
            rate = 9.4
        }
        if term == 0 {
            term = 60.0
        }
        
        type = .decliningBalance
        if let savedType = userDefaults.string(
            forKey: "InterestType") {
            if savedType == "Fixed" {
                type = .fixedFlat
            }
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
    

}
