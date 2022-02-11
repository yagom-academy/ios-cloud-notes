//
//  Note+CoreDataProperties.swift
//  
//
//  Created by 이차민 on 2022/02/11.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var lastModified: Double
    @NSManaged public var body: String?

}
