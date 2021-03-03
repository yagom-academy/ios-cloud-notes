//
//  Note+CoreDataProperties.swift
//  CloudNotes
//
//  Created by Kyungmin Lee on 2021/03/02.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var lastModifiedDate: Date?

}

extension Note : Identifiable {

}
