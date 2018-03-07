//
//  PaymentsTableViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 16.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class PaymentsTableViewController: UITableViewController {
    
    // MARK: - vars
    var payments: Payments?
    var numFormat = ""
    // FIXME:   var loc = Locale.current
    var loc = Locale(identifier: "en_US")
    
    // MARK: - @IBActions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // MARK: Tell view controller to dissapper
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareSchedule(_ sender: UIBarButtonItem) {
        // FIXME: create share action
        print("TODO: print and other schedule sharing")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        changeNumFormat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            if let payment =
                payments?.paymentsSchedule[indexPath.row - 1] {
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
        
        // FIXME: - после скролинга зебра нарушается
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = .veryLightGrey
        }
        
        return cell
    }
    
    // MARK: - extra
    // TODO: create extension??
    func changeNumFormat() {
        if UserDefaults.standard.bool(forKey: "UseDecimals") {
            numFormat = "%.2f"
        } else {
            numFormat = "%.0f"
        }
    }
}
