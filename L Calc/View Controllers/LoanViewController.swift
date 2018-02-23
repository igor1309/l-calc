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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func createGradientLayer() {
        // https://www.appcoda.com/cagradientlayer/
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = colorSets[currentColorSet]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 188/375, y: 154/812)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func createColorSets() {
        colorSets.append([UIColor.red.cgColor, UIColor.yellow.cgColor])
        colorSets.append([UIColor.green.cgColor, UIColor.magenta.cgColor])
        colorSets.append([
            UIColor(red: 29, green: 44, blue: 64).cgColor,
            UIColor(red: 54, green: 73, blue: 97).cgColor
            ])
        
        currentColorSet = 2
    }
}
