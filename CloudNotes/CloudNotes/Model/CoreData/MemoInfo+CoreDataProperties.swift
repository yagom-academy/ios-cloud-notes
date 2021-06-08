//
//  MemoInfo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/08.
//
//

import Foundation
import CoreData


extension MemoInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoInfo> {
        return NSFetchRequest<MemoInfo>(entityName: "MemoInfo")
    }

    @NSManaged public var title: String?
    @NSManaged public var lastModified: Double
    @NSManaged public var body: String?

}

extension MemoInfo : Identifiable {

}
