//
//  MemoDataAccessObject.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/09.
//

import UIKit
import CoreData

class MemoDataAccessObject {
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetchData() -> [Memorable] {
        var memoList = [MemoData]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MemoManagedObject")
        
        let lastModifiedDesc = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [lastModifiedDesc]
        
        do {
            let fetchedSet = try self.context.fetch(fetchRequest)
            
            for record in fetchedSet {
                guard let title = record.value(forKey: "title") as? String,
                      let body = record.value(forKey: "body") as? String,
                      let lastModified = record.value(forKey: "lastModified") as? Double else {
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
