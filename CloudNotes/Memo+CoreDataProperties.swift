//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/27.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var date: Int64
    @NSManaged public var body: String?
    @NSManaged public var title: String?

}

extension Memo : Identifiable {

}
