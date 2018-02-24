//
//  SettingsTableViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 20.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // FIXME: - there is hasLaunchedBefore setting in AppDelegate
    
    var useDecimals = false
    @IBOutlet weak var useDecimalsSwitch: UISwitch!
    
    @IBAction func useDecimalsSwitched(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn,
                                  forKey: "UseDecimals")
        useDecimals = sender.isOn
        // FIXME: - send notification that using decimals swich changed
        // Payments Schedule and Loan Calc should be listening for notification
        NotificationCenter.default.post(
            Notification(name: .decimalsUsageChanged))
    }
    
    var lessHapticFeedback = false
    @IBOutlet weak var lessFeedbackSwitch: UISwitch!
    
    @IBAction func lessFeedbackSwitched(_ sender: UISwitch) {
        // FIXME: - finish code using this Setting
        UserDefaults.standard.set(sender.isOn,
                                  forKey: "LessFeedback")
        lessHapticFeedback = sender.isOn
        // FIXME: - send notification that using less Feedback swich changed
        // Loan should be listening for notification
        NotificationCenter.default.post(
            Notification(name: .lessFeedback))

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        useDecimalsSwitch.isOn = UserDefaults.standard.bool(forKey: "UseDecimals")

    }
    
}
