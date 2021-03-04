//
//  Memo+CoreDataClass.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/24.
//
//

import Foundation
import CoreData

@objc(Memo)
public class Memo: NSManagedObject {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        if let date = self.lastModified {
            return dateFormatter.string(from: date)
        } else {
            return dateFormatter.string(from: Date())
        }
    }
}
