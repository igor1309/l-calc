//
//  SettingsTableViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 20.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var useDecimals: Bool
    
    @IBAction func useDecimalsSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn,
                                  forKey: "UseDecimals")
        useDecimals = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let useDecimals = UserDefaults.standard.bool(forKey: "UseDecimals")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
