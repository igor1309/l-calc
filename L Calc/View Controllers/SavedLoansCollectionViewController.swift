//
//  SavedLoansCollectionViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 17.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class SavedLoansCollectionViewController: UIViewController {
    
    @IBOutlet weak var savedLoansCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedLoansCollectionView.delegate = self
        savedLoansCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //MARK: animation https://www.raywenderlich.com/173544/ios-animation-tutorial-getting-started-3
//        savedLoansCollectionView.center.x -= view.bounds.width
        savedLoansCollectionView.alpha = 0.1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //MARK: animation https://www.raywenderlich.com/173544/ios-animation-tutorial-getting-started-3
        UIView.animate(withDuration: 0.35,
                       delay: 0.15,
                       options: [.curveEaseOut,
                                 .transitionCrossDissolve],
                       animations: {
//                        self.savedLoansCollectionView.center.x += self.view.bounds.width
                        self.savedLoansCollectionView.alpha = 1
        },
                       completion: nil
        )
    }
}

extension SavedLoansCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "savedLoanCell",
            for: indexPath) as! SavedLoanCollectionViewCell
        
        let section = sections[indexPath.row]
        cell.titleLabel.text = section["title"] //FIXME: this line??
        
        let i = indexPath.row + 1
        
        let formatter = NumberFormatter()
        // FIXME: use decimals setting!!
        let amount = Double(1000 * 1000)    //Double(i * 1000 * 1000)
        let rate = 9.40                    //9 + Double(i) / 10
        let term = Double(i) * 10

        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.decimal

        cell.amountLabel.text = String (describing: formatter.string(for: amount)!)
        cell.rateLabel.text = String(format: "%.2f", rate) + "%"
        cell.termLabel.text = String(Int(term))
        let loan: Loan = Loan(amount: amount,
                              rate: rate,
                              term: term,
                              type: InterestType.fixedPrincipal)
        cell.graphView.dataPoints = loan.loanPaymentsMonthlyTotal()
        
        return cell
    }
}

