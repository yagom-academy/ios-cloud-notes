//
//  Note+CoreDataProperties.swift
//  
//
//  Created by 홍정아 on 2021/09/16.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: String
    @NSManaged public var title: String
    @NSManaged public var lastModified: Double

}
