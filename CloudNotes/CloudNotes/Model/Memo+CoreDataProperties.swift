//
//  Memo+CoreDataProperties.swift
//  
//
//  Created by 1 on 2022/02/14.
//
//

import Foundation
import CoreData

extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var lastModified: Int64
    @NSManaged public var body: String?
    @NSManaged public var title: String?

}
