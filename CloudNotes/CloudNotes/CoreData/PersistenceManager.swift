//
//  PersistenceManager.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/15.
//

import Foundation
import CoreData

class PersistenceManager {
    static var shared: PersistenceManager = PersistenceManager()
    
    private init() {}
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Memo")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
 
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createMemo(title: String, body: String, lastModified: TimeInterval) {
        let newMemo = MemoEntity(context: context)
        newMemo.title = title
        newMemo.body = body
        newMemo.lastModified = lastModified
        
        saveContext()
    }
    
    func fetchMemo() -> [MemoEntity] {
        let fetchRequest: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        var memoEntities: [MemoEntity] = []
        
        do {
            memoEntities = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        return memoEntities
    }
    
    func updateMemo(entity: MemoEntity, title: String, body: String, lastModified: TimeInterval) {
        entity.title = title
        entity.body = body
        entity.lastModified = lastModified
        
        saveContext()
    }
    
    func deleteMemo(entity: MemoEntity) {
        context.delete(entity)
        
        saveContext()
    }
}
