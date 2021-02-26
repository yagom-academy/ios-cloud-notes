//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by iluxsm on 2021/02/26.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var lastModified: Date?

}

extension Memo : Identifiable {

}
