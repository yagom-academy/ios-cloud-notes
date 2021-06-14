//
//  MemoData+CoreDataClass.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/09.
//
//

import Foundation
import CoreData

@objc(MemoData)
public class MemoData: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var lastModified: Double
}
