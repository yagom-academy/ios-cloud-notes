//
//  MemoDataAccessObject.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/09.
//

import UIKit
import CoreData
class MemoCoreDataManager {
    static let shared = MemoCoreDataManager()
    private let entityName = "Memo"
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetchData() -> [MemoModel] {
        print("MemoCoreDataManager.fetchData - start")
        var memoList = [MemoData]()
        let fetchRequest: NSFetchRequest<MemoManagedObject> = MemoManagedObject.fetchRequest()
        
        let lastModifiedDesc = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [lastModifiedDesc]
        
        do {
            let fetchedSet = try self.context.fetch(fetchRequest)
            for record in fetchedSet {
                let title = record.title
                let body = record.body
                let lastModified = record.lastModified
                
                let memoData = MemoData(title, body, lastModified, record.objectID)
                memoList.append(memoData)
            }
        } catch {
            NSLog("에러처리 필요 - MemoDataAccessObject.fetchData : %s", error.localizedDescription)
        }
        print("MemoCoreDataManager.fetchData - end - count \(memoList.count)")
        return memoList
    }
    
    func insertData(_ data: MemoModel) {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: self.context) as? MemoManagedObject else {
            print("에러처리 필요 - MemoDataAccessObject.insertData")
            return
        }
        object.title = data.title
        object.body = data.body
        object.lastModified = data.lastModified
        do {
            try self.context.save()
        } catch {
            NSLog("에러처리 필요 - MemoDataAccessObject.insertData : %s", error.localizedDescription)
        }
    }
    
    func deleteData(objectID: NSManagedObjectID) -> Bool {
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        do {
            try self.context.save()
            return true
        } catch {
            NSLog("에러처리 필요 - MemoDataAccessObject.deleteData : %s", error.localizedDescription)
            return false
        }
    }
    
    func editData(by data: MemoData) -> Bool {
        guard let objectID = data.objectID,
              let object = self.context.object(with: objectID) as? MemoManagedObject else {
            NSLog("에러처리 필요 - MemoDataAccessObject.editData : 수정할 객체 object 바인딩 실패")
            return false
        }
        object.title = data.title
        object.body = data.body
        object.lastModified = data.lastModified
        do {
            try self.context.save()
            return true
        } catch {
            self.context.rollback()
            NSLog("에러처리 필요 - MemoDataAccessObject.editData : %s", error.localizedDescription)
            return false
        }
    }
}
