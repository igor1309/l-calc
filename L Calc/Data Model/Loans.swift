//
//  Loans.swift
//  L Calc
//
//  Created by Igor Malyarov on 23.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import Foundation

class Loans {
    
    struct LoanParams {
        var amount: Double
        var rate: Double
        var term: Double
        var type: Loan.InterestType
    }
    
    var loansStorage = [Loan]()
    
    init() {
        for i in 1...6 {
            loansStorage.append(Loan(
                1000000.0,
                9.0 + Double(i/10),
                10.0 + Double(i),
                .decliningBalance))
        }
    }
}
