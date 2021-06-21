//
//  NoteData+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/14.
//
//

import Foundation
import CoreData


extension NoteData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteData> {
        return NSFetchRequest<NoteData>(entityName: "NoteData")
    }

    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var lastModifiedDate: Date?

}

extension NoteData : Identifiable {
    
}
