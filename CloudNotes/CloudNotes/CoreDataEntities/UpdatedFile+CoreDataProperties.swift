//
//  UpdatedFile+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/06.
//
//

import Foundation
import CoreData


extension UpdatedFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UpdatedFile> {
        return NSFetchRequest<UpdatedFile>(entityName: "UpdatedFile")
    }

    @NSManaged public var name: String?

}

extension UpdatedFile : Identifiable {

}
