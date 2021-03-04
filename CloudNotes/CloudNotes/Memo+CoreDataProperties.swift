//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/24.
//
//

import Foundation
import CoreData

extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var registerDate: Date

}

extension Memo : Identifiable {

}
