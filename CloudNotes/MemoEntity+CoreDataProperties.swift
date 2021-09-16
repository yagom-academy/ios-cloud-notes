//
//  MemoEntity+CoreDataProperties.swift
//  
//
//  Created by 김준건 on 2021/09/17.
//
//

import Foundation
import CoreData


extension MemoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoEntity> {
        return NSFetchRequest<MemoEntity>(entityName: "MemoEntity")
    }

    @NSManaged public var body: String?
    @NSManaged public var lastModifiedDate: Date?
    @NSManaged public var title: String?

}
