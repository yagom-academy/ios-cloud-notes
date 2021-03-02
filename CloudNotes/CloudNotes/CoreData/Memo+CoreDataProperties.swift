//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/03/03.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String?
    @NSManaged public var contents: String?
    @NSManaged public var lastModifiedDate: Date?

}

extension Memo : Identifiable {

}
