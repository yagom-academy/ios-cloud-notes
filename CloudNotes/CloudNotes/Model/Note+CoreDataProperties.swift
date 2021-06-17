//
//  Note+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/13.
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
    @NSManaged public var lastModify: Date?

}

extension Note : Identifiable {

}
