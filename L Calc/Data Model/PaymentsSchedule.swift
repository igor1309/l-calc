//
//  PaymentsSchedule.swift
//  L Calc
//
//  Created by Igor Malyarov on 17.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
//
// http://financeformulas.net/Annuity_Payment_Formula.html
// http://www.thecalculatorsite.com/finance/calculators/loancalculator.php
// https://brownmath.com/bsci/loan.htm
// https://stackoverflow.com/questions/27745263/create-loop-for-amortization-schedule-in-swift
//

import Foundation

class Payments {
    
    struct Payment {
        var beginningBalance: Double
        var interest: Double
        var principal: Double
        var monthlyPayment: Double
        var endingBalance: Double
    }

//    struct Payment {
//        var beginningBalance = Double(0)
//        var interest = Double(0)
//        var principal = Double(0)
//        var monthlyPayment = Double(0)
//        var endingBalance = Double(0)
//    }

    var paymentsSchedule = [Payment]()

    // MARK: - init
    
    init (for loan: Loan) {
        // using: loan.amount loan.rate loan.term loan.type: InterestType

        let r = loan.rate / 100 / 12    // monthly interest rate

        switch loan.type {
        case .decliningBalance:     // аннуитет w/fixed monthly payment
            let monthlyPayment = loan.amount /
                ((1 - pow(1 + r, Double(0 - loan.term))) / r)
            
            for i in 1...Int(loan.term) {
                let beginningBalance =
                    loan.amount * pow(1 + r, Double (i - 1)) -
                    monthlyPayment / r * (pow(1 + r, Double (i - 1)) - 1)
                let endingBalance =
                    loan.amount * pow(1 + r, Double (i)) -
                    monthlyPayment / r * (pow(1 + r, Double (i)) - 1)
                let principal =
                    beginningBalance - endingBalance
                let interest =
                    monthlyPayment - principal

                let payment = Payment(
                    beginningBalance: beginningBalance,
                    interest: interest,
                    principal: principal,
                    monthlyPayment: monthlyPayment,
                    endingBalance: endingBalance)
                paymentsSchedule.append(payment)
            }
        case .fixedFlat:
            print("допилить таблицу для выплаты в конце срока")
            //FIXME: допилить таблицу для выплаты в конце срока??
//            payment.monthlyPayment =
//                loan.amount * r
        }
    }
    
/*
    convenience init (amount: Double = 5000000.0,
                      rate: Double = 9.4,
                      term: Double = 12.0,
                      type: Loan.InterestType = .decliningBalance) {
        self.init(for: Loan(amount, rate, term, type))
    }
 */
    
    convenience init (
        amount: Double = UserDefaults.standard.double(forKey: "Principal"),
        rate: Double = UserDefaults.standard.double(
        forKey: "Rate"),
        term: Double = UserDefaults.standard.double(
        forKey: "Term"),
        // FIXME: forKey: "AnnuitySegment"
        type: Loan.InterestType = .decliningBalance) {
        
        self.init(for: Loan(amount, rate, term, type))
    }

    
}
