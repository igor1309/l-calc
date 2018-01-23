//
//  PaymentsTableViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 16.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class PaymentsTableViewController: UITableViewController {
    
    var payments: Payments?
    var numFormat = ""
    // FIXME:   var loc = Locale.current
    var loc = Locale(identifier: "en_US")
    

    // TODO: настроить передачу Loan из основного view controller
    
//    var loan: Loan

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // FIXME: Tell view controller to dissapper
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareSchedule(_ sender: UIBarButtonItem) {
        // FIXME: create share action
        print("TODO: print and other schedule sharing")
    }
    

    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeNumFormat()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let numOfRows =
            payments?.paymentsSchedule.count {
            return numOfRows + 1
        } else {
            return 1
        }
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

//        let r = (loan.rate) / 100 / 12    // monthly interest rate
        //            if annuitySegment.selectedSegmentIndex == 1 {
        //  выбран аннуитет
        //  http://financeformulas.net/Annuity_Payment_Formula.html
        // http://www.thecalculatorsite.com/finance/calculators/loancalculator.php
//        let p = pow(1 + r, 0 - (loan.term))
//        let monthlyPayment = (loan.amount) / ((1 - p) / r)
        
        
        //         } else {     // выплата в конце срока
        // FIXME: допилить расчет
        
//        totalPayment.font = totalPayment.font.bold()

        if indexPath.row == 0 {
            month.text = "#"
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
            if let payment = payments?.paymentsSchedule[indexPath.row - 1] {
            month.text =
                String(format: "%d",
                       locale: loc,
                       indexPath.row)
            beginningBalance.text =
                String(format: numFormat,
                       locale: loc,
                       payment.beginningBalance)
            interest.text =
                String(format: numFormat,
                       locale: loc,
                       payment.interest)
            principal.text =
                String(format: numFormat,
                       locale: loc,
                       payment.principal)
            totalPayment.text =
                String(format: numFormat,
                       locale: loc,
                       payment.monthlyPayment)
            endingBalance.text =
                String(format: numFormat,
                       locale: loc,
                       payment.endingBalance)
            }
        }
        
        return cell
    }
    
    func changeNumFormat() {
        if UserDefaults.standard.bool(forKey: "UseDecimals") {
            numFormat = "%.2f"
        } else {
            numFormat = "%.0f"
        }
    }
}
