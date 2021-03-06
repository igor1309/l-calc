//
//  PaymentsTableViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 16.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class PaymentsTableViewController: UITableViewController {
    
    // FIXME:   var loc = Locale.current
    var loc = Locale(identifier: "en_US")

    
    // FIXME: move everything to data model (?)
    
    var amount = Double(5000000)
    var rate = Double(9.4)
    var term = Double(13)
//    var amount = UserDefaults.standard.double(forKey: "Principal")
//    var rate = UserDefaults.standard.double(forKey: "Rate")
//    var term = UserDefaults.standard.double(forKey: "Term")
    // FIXME: forKey: "AnnuitySegment"
    
    var payments = Payments(for: Loan(5000000.0, 9.4, 13.0, .decliningBalance))
    
    override func viewDidAppear(_ animated: Bool) {
//        print(calcPaymentsSchedule(loan: Loan(amount, rate, term, .decliningBalance)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payments = Payments(for: Loan(amount, rate, term, .decliningBalance))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Int(term) + 1
    }

    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MonthlyPayment",
            for: indexPath)


        let month = cell.viewWithTag(1006) as! UILabel
        let beginningBalance = cell.viewWithTag(1001) as! UILabel
        let interest = cell.viewWithTag(1002) as! UILabel
        let principal = cell.viewWithTag(1003) as! UILabel
        let totalPayment = cell.viewWithTag(1004) as! UILabel
        let endingBalance = cell.viewWithTag(1005) as! UILabel

        let r = rate / 100 / 12    // monthly interest rate
        //            if annuitySegment.selectedSegmentIndex == 1 {
        //  выбран аннуитет
        //  http://financeformulas.net/Annuity_Payment_Formula.html
        // http://www.thecalculatorsite.com/finance/calculators/loancalculator.php
        let p = pow(1 + r, 0 - term)
        let monthlyPayment = amount / ((1 - p) / r)
        totalPayment.text = String(format: "%.2f",
                                   locale: loc,
                                   monthlyPayment)
        
        //         } else {     // выплата в конце срока
        // FIXME: допилить расчет
        
//        totalPayment.font = totalPayment.font.bold()

        if indexPath.row == 0 {
            month.text = "##"
//            month.font = month.font.bold()
            beginningBalance.text = "-> BALANCE"
//            beginningBalance.font = beginningBalance.font.bold()
            interest.text = "INTEREST"
//            interest.font = interest.font.bold()
            principal.text = "PRINCIPAL"
//            principal.font = principal.font.bold()
            totalPayment.text = "PAYMENT"
            endingBalance.text = "BALANCE ->"
//            endingBalance.font = endingBalance.font.bold()

        } else {
            let payment = payments.paymentsSchedule[indexPath.row - 1]
            month.text =
                String(format: "%d",
                       locale: loc,
                       indexPath.row)
            beginningBalance.text =
                String(format: "%.2f",
                       locale: loc,
                       payment.beginningBalance)
            interest.text =
                String(format: "%.2f",
                       locale: loc,
                       payment.interest)
            principal.text =
                String(format: "%.2f",
                       locale: loc,
                       payment.principal)
            endingBalance.text =
                String(format: "%.2f",
                       locale: loc,
                       payment.endingBalance)
        }
        
        return cell
    }
    
    /*
     struct Payment {
     var beginningBalance: Double
     var interest: Double
     var principal: Double
     var totalPayment: Double
     var endingBalance: Double
     }
     
     // NSDecimalNumber monthlyPayment = LoanAmount * interestRateDecimal / (1 - (pow(1/(1 + interestRateDecimal), months)));
     
     // https://stackoverflow.com/questions/27745263/create-loop-for-amortization-schedule-in-swift
     
     func calcPaymentsSchedule(loan: Loan) -> [Payment] {
     var payments = [Payment]()
     for m in 1...Int(loan.term) {
     let beginningBalance = loan.amount + Double(m)
     let interest = loan.amount * loan.rate / 100
     let principal = loan.amount / loan.term
     let totalPayment = interest + principal
     let endingBalance = beginningBalance - principal
     let pay = Payment(beginningBalance: beginningBalance,
     interest: interest,
     principal: principal,
     totalPayment: totalPayment,
     endingBalance: endingBalance
     )
     
     payments.append(pay)
     }
     return payments
     }
     */
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
