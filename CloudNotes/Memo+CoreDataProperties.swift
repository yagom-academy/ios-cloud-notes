//
//  Memo+CoreDataProperties.swift
//  
//
//  Created by 예거 on 2022/02/14.
//
//

import CoreData

extension Memo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastModified: Double
    @NSManaged public var title: String?
}
