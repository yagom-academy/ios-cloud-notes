//
//  MemoManagedObject+CoreDataProperties.swift
//  
//
//  Created by Yongwoo Marco on 2021/09/10.
//
//

import Foundation
import CoreData

extension MemoManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoManagedObject> {
        return NSFetchRequest<MemoManagedObject>(entityName: "Memo")
    }

    @NSManaged public var title: String
    @NSManaged public var lastModified: Double
    @NSManaged public var body: String
}
