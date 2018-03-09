//
//  CDLoan+CoreDataClass.swift
//  L Calc
//
//  Created by Igor Malyarov on 26.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CDLoan)
public class CDLoan: NSManagedObject {
    
    //MARK: Initializer

    convenience init(context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "CDLoan", in: context) {
            self.init(entity: ent, insertInto: context)
            // FIXME: - finish the initializer
            self.creationDate = Date()
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
    //MARK: Computed Property
    
    var humanReadableAge: String {
        get {
            let fmt = DateFormatter()
            fmt.timeStyle = .short
            fmt.dateStyle = .short
            fmt.doesRelativeDateFormatting = true
            fmt.locale = Locale.current
            return fmt.string(from: creationDate! as Date)
        }
    }
    
}
