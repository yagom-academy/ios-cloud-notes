//
//  Note+CoreDataProperties.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/11.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var lastModified: Date

}

extension Note: Identifiable {

}
