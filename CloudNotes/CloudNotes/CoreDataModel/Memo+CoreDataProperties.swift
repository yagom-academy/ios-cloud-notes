//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/04.
//
//

import Foundation
import CoreData

extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String
    @NSManaged public var memoDescription: String
    @NSManaged public var date: Double

}

extension Memo: Identifiable {

}
