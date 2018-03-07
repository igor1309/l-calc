//
//  GraphViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 24.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class Graph2ViewController: UIViewController {

    @IBOutlet weak var graph2: GraphView2!

    var loan: Loan?

    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func graphTabDetected(_ sender: UITapGestureRecognizer) {
        graph2.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let loan = loan {
            graph2.gPoints1 = loan.loanPaymentsMonthlyTotal()
            graph2.gPoints2 = loan.loanPaymentsMonthlyPrincipal()
        }
    }
}
