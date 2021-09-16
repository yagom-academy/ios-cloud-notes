//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/15.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    static let shared = CoreDataManager()
    var memoList = [MemoEntity]()
    private init() {}
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    func addNewMemo(title: String, body: String, lastModifiedDate: Date) {
        let newMemo = MemoEntity(context: mainContext)
        newMemo.title = title
        newMemo.body = body
        newMemo.lastModifiedDate = lastModifiedDate
        memoList.insert(newMemo, at: 0)
        
        saveContext()
    }
    
    func updateMemo(modifyMemo: MemoEntity, with indexPath: IndexPath) {
        var modifyEntity = memoList[indexPath.row]
        modifyEntity = modifyMemo
        saveContext()
    }
}
