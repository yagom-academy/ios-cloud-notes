//
//  MemoDataAccessObject.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/09.
//

import UIKit
import CoreData

class MemoDataAccessObject: NSObject {
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetchData() -> [Memorable] {
        var memoList = [MemoData]()
        let keys = MemoData.MemoKeys.self
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.className)
        
        let lastModifiedDesc = NSSortDescriptor(key: keys.lastModified.key, ascending: false)
        fetchRequest.sortDescriptors = [lastModifiedDesc]
        
        do {
            let fetchedSet = try self.context.fetch(fetchRequest)
            
            for record in fetchedSet {
                guard let title = record.value(forKey: keys.title.key) as? String,
                      let body = record.value(forKey: keys.body.key) as? String,
                      let lastModified = record.value(forKey: keys.lastModified.key) as? Double else {
                    continue
                }
                
                let memoData = MemoData(title, body, lastModified, record.objectID)
                memoList.append(memoData)
            }
        } catch {
            print("에러처리 필요 - MemoDataAccessObject.fetchData : %s", error.localizedDescription)
        }
        return memoList
    }
}
