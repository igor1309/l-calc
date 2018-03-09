//
//  ListOfLoans+CoreDataClass.swift
//  L Calc
//
//  Created by Igor Malyarov on 26.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ListOfLoans)
public class ListOfLoans: NSManagedObject {

    //MARK: Initializer
    
    convenience init(context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "ListOfLoans", in: context) {
            self.init(entity: ent, insertInto: context)
            // FIXME: - finish the initializer
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
