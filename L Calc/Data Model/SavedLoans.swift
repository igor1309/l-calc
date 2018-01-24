//
//  Loans.swift
//  L Calc
//
//  Created by Igor Malyarov on 23.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import Foundation

class SavedLoans {
    
    struct LoanParams {
        var amount: Double
        var rate: Double
        var term: Double
        var type: InterestType
    }
    
    var loansStorage = [LoanParams]()
    
    init() {
        // FIXME: replace dummy array with real data
        for i in 1...16 {
            loansStorage.append(
                LoanParams(
                    amount: Double(i) * 1000000.0,
                    rate: 9.0 + Double(i) / 10.0,
                    term: 10.0 + Double(i),
                    type: .decliningBalance)
            )
        }
    }
    
    // FIXME: - save data to disk
    
}
