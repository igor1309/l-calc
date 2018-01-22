//
//  LoanCalculation.swift
//  L Calc
//
//  Created by Igor Malyarov on 10.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class LoanCalculationController: UIViewController {

//    @IBOutlet weak var iceCreamDescription: UILabel!
//    @IBOutlet weak var iceCreamPriceLabel: UILabel!
    
    var principal: Double = 0.0
    var rate: Double = 9.4
    var term: Double = 60
//    var type: Loan.InterestType         // MARK: ЗДЕСЬ ПРОБЛЕМА
    var type: String = "fixedFlat"
    
    // MARK: КАК ПРАВИЛЬНО ИНИЦИАЛИЗИРОВАТЬ С УЧЕТОМ СОХРАННЕННЫХ ЗНАЧЕНИЙ???
    let loan = Loan(4.6 * pow(10, 6), 9.4, 60.0, Loan.InterestType.fixedFlat)

    @IBAction func didChangePrincipal(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        //  MARK: TODO: закончить код
        refreshDisplay()
    }
    
    @IBAction func didChangeRate(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        //  MARK: TODO: закончить код
        refreshDisplay()
    }
    
    @IBAction func didChangeTerm(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        //  MARK: TODO: закончить код
        refreshDisplay()
    }
    
    func refreshDisplay() {
        //  MARK: TODO: закончить код
        print(principal)
        print(rate)
        print(term)
        print(type)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLoan()
        refreshDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//MARK: Private Methods

    private func loadLoan() {       // MARK: или это не должно быть во ViewController?
        
        //  MARK: TODO: закончить код
        let defaults = UserDefaults.standard
        
        principal = defaults.double(
            forKey: "Principal")
        rate = defaults.double(
            forKey: "Rate")
        term = defaults.double(
            forKey: "Term")

        let t = defaults.string(
            forKey: "InterestType") ?? "Annuity"
        type = (Loan.InterestType(rawValue: t)?.rawValue)!
    }

}
