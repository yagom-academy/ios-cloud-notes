//
//  Note+CoreDataProperties.swift
//  
//
//  Created by 서녕 on 2022/02/14.
//
//

import Foundation
import CoreData

extension Note {
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var lastModifiedDate: Double
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
}
