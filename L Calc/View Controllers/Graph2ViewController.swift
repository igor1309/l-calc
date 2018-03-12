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
    @IBOutlet weak var interestTypeLabel: UILabel!
    
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
            graph2.gPoints1 = loan.loanPaymentsMonthlyPrincipal()
//            print(graph2.gPoints1)
//            print(graph2.gPoints2)
            graph2.gPoints2 = loan.loanPaymentsMonthlyInterest()
            interestTypeLabel.text = loan.interestTypeComment[loan.type]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}
