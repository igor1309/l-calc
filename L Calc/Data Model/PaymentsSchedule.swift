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
        case .interestOnly:
            let beginningBalance = loan.amount
            let endingBalance = loan.amount
            let interest = loan.amount * r
            let monthlyPayment = interest
            for _ in 1..<Int(loan.term) {
                let payment = Payment(
                    beginningBalance: beginningBalance,
                    interest: interest,
                    principal: 0,
                    monthlyPayment: monthlyPayment,
                    endingBalance: endingBalance)
                paymentsSchedule.append(payment)
            }
            let payment = Payment(
                beginningBalance: loan.amount,
                interest: interest,
                principal: loan.amount,
                monthlyPayment: interest + loan.amount,
                endingBalance: 0)
            paymentsSchedule.append(payment)
                
        case .fixedPayment:     // аннуитет = fixed monthly payment
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

        case .fixedPrincipal:
            let principal = loan.amount / loan.term
            for i in 1...Int(loan.term) {
                let beginningBalance =
                    loan.amount * (1 - Double (i - 1) / loan.term)
                let endingBalance =
                    loan.amount * (1 - Double (i) / loan.term)
                let interest = beginningBalance * r
                let monthlyPayment = principal + interest
                let payment = Payment(
                    beginningBalance: beginningBalance,
                    interest: interest,
                    principal: principal,
                    monthlyPayment: monthlyPayment,
                    endingBalance: endingBalance)
                paymentsSchedule.append(payment)
            }
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
        type: InterestType = .fixedPayment) {
        
        self.init(for: Loan(amount, rate, term, type))
    }

    
}
