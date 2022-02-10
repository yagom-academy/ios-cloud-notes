//
//  MemoData+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 박병호 on 2022/02/10.
//
//

import Foundation
import CoreData


extension MemoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }

    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var lastModified: Double

}

extension MemoData : Identifiable {

}
