//
//  LoansTableViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 23.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class LoansTableViewController: UITableViewController {
    
    let loans = SavedLoans.init()
    var loansStorage = [SavedLoans.LoanParams]()
    
    // FIXME:   var loc = Locale.current
    var loc = Locale(identifier: "en_US")
    
    var numFormat = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        loansStorage = loans.loansStorage
        
        

//        print(loansStorage)
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loansStorage.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SavedLoan",
            for: indexPath)

        let amountLabel = cell.viewWithTag(1001) as! UILabel
        let termLabel = cell.viewWithTag(1002) as! UILabel
        let rateLabel = cell.viewWithTag(1003) as! UILabel
        let typeLabel = cell.viewWithTag(1004) as! UILabel

        let savedLoan = loansStorage[indexPath.row]

        amountLabel.text = String(format: "%.0f",
                                  locale: loc,
                                  savedLoan.amount)
        termLabel.text = String(format: "%.0f",
                                locale: loc,
                                savedLoan.term)
        rateLabel.text = String(format: "%.2f",
                                locale: loc,
                                savedLoan.rate) + "%"
        typeLabel.text = String(savedLoan.type.rawValue)
/*
        // FIXME: - после скролинга зебра нарушается
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = .veryLightGrey
        }
*/
        return cell
    }
    
    // FIXME: - func not called!
    func tableView(tableView: UITableView,
                   willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = .veryLightGrey
        }
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: true)
        
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
        
        // FIXME: - send selected loansStorage[indexPath.row] to Loan view controller to show selected loan
        print(loansStorage[indexPath.row])
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            loansStorage.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath],
                                 with: .automatic)
        }
    }
 

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView,
                            moveRowAt fromIndexPath: IndexPath,
                            to: IndexPath) {
        // FIXME: make rows movable

    }
    


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
