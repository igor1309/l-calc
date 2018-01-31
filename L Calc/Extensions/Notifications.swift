//
//  Notifications.swift
//  L Calc
//
//  Created by Igor Malyarov on 21.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let decimalsUsageChanged =
        Notification.Name("decimalsUsageChanged")
    
    static let lessFeedback =
        Notification.Name("lessFeedback")
    
    static let loanChanged =
        Notification.Name("loanChanged")
    
    static let outOfRange =
        Notification.Name("outOfRange")

}
