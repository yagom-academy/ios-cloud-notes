//
//  CDMemo+CoreDataProperties.swift
//  
//
//  Created by 1 on 2022/02/15.
//
//

import Foundation
import CoreData


extension CDMemo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMemo> {
        return NSFetchRequest<CDMemo>(entityName: "CDMemo")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var lastModified: Date?

}
