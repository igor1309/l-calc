//
//  LoanViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 23.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class LoanViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.applyGradient()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: нужно разобраться, как отменять эти изменения
        // чтобы navigationController в последующих VC не портить
/*        if let navBar = self.navigationController?.navigationBar {
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.isTranslucent = true
        }
*/
    }
    
/*
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //FIXME: too buggy code — animation sucks
        if let navBar = self.navigationController?.navigationBar {
            navBar.isTranslucent = false

        self.navigationController?
            .navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?
            .navigationBar.barTintColor = .black
        }
    }
     */

}
