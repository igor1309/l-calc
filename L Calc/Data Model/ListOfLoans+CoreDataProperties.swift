//
//  ListOfLoans+CoreDataProperties.swift
//  L Calc
//
//  Created by Igor Malyarov on 26.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
//

import Foundation
import CoreData


extension ListOfLoans {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListOfLoans> {
        return NSFetchRequest<ListOfLoans>(entityName: "ListOfLoans")
    }

    @NSManaged public var name: String?
    @NSManaged public var loan: NSSet?

}

//MARK: Generated accessors for loan
extension ListOfLoans {

    @objc(addLoanObject:)
    @NSManaged public func addToLoan(_ value: CDLoan)

    @objc(removeLoanObject:)
    @NSManaged public func removeFromLoan(_ value: CDLoan)

    @objc(addLoan:)
    @NSManaged public func addToLoan(_ values: NSSet)

    @objc(removeLoan:)
    @NSManaged public func removeFromLoan(_ values: NSSet)

}
