//
//  GraphViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 24.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class Graph2ViewController: UIViewController {
    
    // background color 1D2C40 и 323645
    
    let interestColor = UIColor.white
    let principalColor = UIColor(hexString: "D1D1D1")

    var loan: Loan?

    @IBOutlet weak var interestTypeLabel: UILabel!
    @IBOutlet weak var interestTypeCommentLabel: UILabel!
    @IBOutlet weak var graph: TwoBarsView!
    @IBOutlet weak var interestColorLegendView: UIView!
    @IBOutlet weak var principalColorLegendView: UIView!
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func graphTabDetected(_ sender: UITapGestureRecognizer) {
        graph.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let loan = loan {
            graph.principalPoints = loan.loanPaymentsMonthlyPrincipal()
            graph.interestPoints = loan.loanPaymentsMonthlyInterest()
            //            print(graph2.gPoints1)
            //            print(graph2.gPoints2)
            graph.principalColor = principalColor
            graph.interestColor = interestColor
            interestTypeLabel.text = loan.interestTypeName[loan.type]
            interestTypeCommentLabel.text = loan.interestTypeComment[loan.type]
            principalColorLegendView.backgroundColor = principalColor
            interestColorLegendView.backgroundColor = interestColor
        }
    }
    
}
