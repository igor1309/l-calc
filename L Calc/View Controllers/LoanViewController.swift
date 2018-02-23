//
//  LoanViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 23.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class LoanViewController: UIViewController {
    
    var gradientLayer: CAGradientLayer!
    var colorSets = [[CGColor]]()
    var currentColorSet: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        createColorSets()
        createGradientLayer()
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


    func createGradientLayer() {
        // https://www.appcoda.com/cagradientlayer/
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = colorSets[currentColorSet]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint =
            CGPoint(x: 188/375, y: 154/812)
        gradientLayer.endPoint =
            CGPoint(x: 1.0, y: 1.0)
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func createColorSets() {
        colorSets.append([UIColor.red.cgColor, UIColor.yellow.cgColor])
        colorSets.append([UIColor.green.cgColor, UIColor.magenta.cgColor])
        colorSets.append([
            UIColor(rgb: 0x1D2C40).cgColor,
            UIColor(rgb: 0x364961).cgColor])
        colorSets.append([
            UIColor(red: 29, green: 44, blue: 64).cgColor,
            UIColor(red: 54, green: 73, blue: 97).cgColor
            ])
        
        currentColorSet = 2
    }
}
