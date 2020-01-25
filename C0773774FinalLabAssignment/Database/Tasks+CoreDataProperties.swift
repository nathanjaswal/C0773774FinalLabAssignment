//
//  Tasks+CoreDataProperties.swift
//  C0773774FinalLabAssignment
//
//  Created by Nitin on 24/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var productId: String?
    @NSManaged public var productName: String?
    @NSManaged public var productDes: String?
    @NSManaged public var productPrice: String?

}
