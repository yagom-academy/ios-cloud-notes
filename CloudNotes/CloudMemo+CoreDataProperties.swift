//
//  CloudMemo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/09.
//
//

import Foundation
import CoreData

extension CloudMemo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CloudMemo> {
        return NSFetchRequest<CloudMemo>(entityName: "CloudMemo")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var lastModified: Date?

}

extension CloudMemo: Identifiable {

}
