//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by steven on 2021/06/09.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {
        
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var entity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "Memo", in: mainContext)
    }
    
    func makeNewMeno() -> Memo {
//        let newMemo = NSManagedObject(entity: entity!, insertInto: mainContext)
//        newMemo.setValue("새로운제목", forKey: "title")
//        newMemo.setValue("새로운 내용이다!!", forKey: "body")
//        newMemo.setValue(Date(), forKey: "lastModified")
        let newMemo = Memo(context: mainContext)
//        newMemo.title = "객체를 직접 만들어서 제목!!!!"
//        newMemo.body = "객체를 직접 바디!!!!!"
        newMemo.lastModified = Date()
//        saveContext()
        return newMemo
    }
    
    func editMemo(memo: Memo, title: String, body: String) {
        memo.title = title
        memo.body = body
        saveContext()
    }
    
    func fetchMemos() -> [Memo] {
        guard let memos = try? mainContext.fetch(Memo.fetchRequest()) as? [Memo] else {
            return []
        }
        return memos
    }
    
    func deleteAllMemos() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Memo.fetchRequest())
        do {
            try mainContext.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data stack
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
