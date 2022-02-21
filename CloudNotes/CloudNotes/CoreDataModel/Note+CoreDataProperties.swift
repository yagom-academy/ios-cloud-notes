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
    
    static let entityName = "Note"
    
    static let titleKey = "title"
    static let contentKey = "content"
    static let lastModifiedDateKey = "lastModifiedDate"
    
    
    var localizedDateString: String {
        return DateFormatter().localizedString(from: self.lastModifiedDate)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
}
