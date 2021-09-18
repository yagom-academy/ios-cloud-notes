//
//  Note+CoreDataProperties.swift
//  
//
//  Created by Dasoll Park on 2021/09/18.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: String?
    @NSManaged public var lastModified: Int64
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?

}
