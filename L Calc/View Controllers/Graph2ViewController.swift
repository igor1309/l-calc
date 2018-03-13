//
//  GraphViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 24.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class Graph2ViewController: UIViewController {

    @IBOutlet weak var interestTypeLabel: UILabel!
    @IBOutlet weak var interestTypeCommentLabel: UILabel!
    @IBOutlet weak var graph2: TwoBarsView!
    @IBOutlet weak var interestColorLegendView: UIView!
    @IBOutlet weak var principalColorLegendView: UIView!
    

    let interestColor = UIColor.white
    let principalColor = UIColor.cyan
    
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
            graph2.graphPoints1 = loan.loanPaymentsMonthlyPrincipal()
            graph2.graphPoints2 = loan.loanPaymentsMonthlyInterest()
            //            print(graph2.gPoints1)
            //            print(graph2.gPoints2)
            graph2.principalColor = principalColor
            graph2.interestColor = interestColor
            interestTypeLabel.text = String(loan.type.rawValue)
            interestTypeCommentLabel.text = loan.interestTypeComment[loan.type]
            principalColorLegendView.backgroundColor = principalColor
            interestColorLegendView.backgroundColor = interestColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}
