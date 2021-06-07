//
//  MemoListItem+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/07.
//
//

import Foundation
import CoreData


extension MemoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoListItem> {
        return NSFetchRequest<MemoListItem>(entityName: "MemoListItem")
    }

    @NSManaged public var body: String?
    @NSManaged public var lastModifiedDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var blankOverTitle: String?
    @NSManaged public var blankBetweenTitleAndBody: String?

}

extension MemoListItem : Identifiable {

}
