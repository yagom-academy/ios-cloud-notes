//
//  File.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/11.
//

import UIKit
import CoreData

class MemoDataManager {
    static var memos: [Memo]?
    
    static let context: NSManagedObjectContext = { () -> NSManagedObjectContext in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
}
