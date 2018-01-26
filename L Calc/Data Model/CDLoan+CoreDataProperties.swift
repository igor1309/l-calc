//
//  CDLoan+CoreDataProperties.swift
//  L Calc
//
//  Created by Igor Malyarov on 26.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
//

import Foundation
import CoreData


extension CDLoan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDLoan> {
        return NSFetchRequest<CDLoan>(entityName: "CDLoan")
    }

    @NSManaged public var amount: Double
    @NSManaged public var rate: Double
    @NSManaged public var term: Int16
    @NSManaged public var type: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var listOfLoans: ListOfLoans?

}
