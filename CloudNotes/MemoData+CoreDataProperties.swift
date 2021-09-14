//
//  MemoData+CoreDataProperties.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/14.
//
//

import Foundation
import CoreData


extension MemoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Date?

}

extension MemoData : Identifiable {

}
