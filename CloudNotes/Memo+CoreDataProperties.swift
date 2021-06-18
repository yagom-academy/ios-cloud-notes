//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/17.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var body: String
    @NSManaged public var lastModifiedDate: Date
    @NSManaged public var title: String

}

extension Memo : Identifiable {

}
