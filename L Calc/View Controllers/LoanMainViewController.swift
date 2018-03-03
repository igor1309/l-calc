//
//  LoanMainViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 04.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class LoanMainViewController: UIViewController {
    
    @IBOutlet weak var sum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.applyGradient()
        
        sum.text = "456,123"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //FIXME: TODO: нужно разобраться, как отменять эти изменения
        // чтобы navigationController в последующих VC не портить
        if let navBar = self.navigationController?.navigationBar {
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
            navBar.tintColor = UIColor(hexString: "EBEBEB")
        }
        
    }
}
