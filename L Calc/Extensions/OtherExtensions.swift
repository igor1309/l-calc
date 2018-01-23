//
//  OtherExtensions.swift
//  L Calc
//
//  Created by Igor Malyarov on 23.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import Foundation

// from https://www.objc.io/blog/2018/01/16/toggle-extension-on-bool/

extension Bool {
    mutating func toggle() {
        self = !self
    }
}
