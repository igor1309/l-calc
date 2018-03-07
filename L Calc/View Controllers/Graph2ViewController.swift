//
//  GraphViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 24.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

extension Loan {
    func loanPaymentsMonthlyTotal() -> [Int] {
        
        let r = rate / 100 / 12    // monthly interest rate
        var a = [Int]()
        
        switch type {
        case .fixedPayment:    // аннуитет w/fixed monthly payment
            let monthlyPayment = amount /
                ((1 - pow(1 + r, Double(0 - term))) / r)
            for _ in 1...Int(term) {
                a.append(Int(monthlyPayment))
            }
        case .interestOnly:
            print("допилить таблицу для выплаты в конце срока")
            //FIXME: допилить таблицу для выплаты в конце срока??
            //            payment.monthlyPayment =
        //                loan.amount * r
        case .fixedPrincipal:
            //FIXME: PROVIDE CALCULATIONS FOR THIS TYPE
            print("??")
        }
        return a
    }
}

class Graph2ViewController: UIViewController {

    @IBOutlet weak var graph2: GraphView2!

    var loan: Loan?

    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let loan = loan {
            graph2.gPoints1 = loan.loanPaymentsMonthlyTotal()
            graph2.gPoints2 = loan.loanPaymentsMonthlyTotal()
        }
    }
}
