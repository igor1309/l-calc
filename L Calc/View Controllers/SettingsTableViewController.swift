//
//  SettingsTableViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 20.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var useDecimals = false
    @IBOutlet weak var useDecimalsSwitch: UISwitch!
    
    @IBAction func useDecimalsSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn,
                                  forKey: "UseDecimals")
        useDecimals = sender.isOn
        // FIXME: send notification that using decimals swich changed
        // Payments Schedule and Loan Calc should be listening for notification
        NotificationCenter.default.post(
            Notification(name: .decimalsUsageChanged))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useDecimalsSwitch.isOn = UserDefaults.standard.bool(forKey: "UseDecimals")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension Notification.Name {
    static let decimalsUsageChanged = Notification.Name("decimalsUsageChanged")
}
