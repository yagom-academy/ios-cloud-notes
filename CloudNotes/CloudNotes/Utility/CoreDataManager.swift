//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/11.
//

import UIKit
import CoreData

final class CoreDataManager {
    lazy var context = persistentContainer.newBackgroundContext()
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CloudNotes")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("persistent stores Loading Failure : \(error)")
            }
        }
        return container
    }()
    
    // MARK: - CoreData CRUD
    
    func create(id: UUID = UUID(), title: String = .blank, body: String = .blank, lastModified: TimeInterval = Date().timeIntervalSince1970) {
        guard let memoEntity = NSEntityDescription.entity(forEntityName: "Memo", in: context) else {
            return
        }
        
        let memoManagedObject = NSManagedObject(entity: memoEntity, insertInto: context)
        
        memoManagedObject.setValue(id, forKey: "id")
        memoManagedObject.setValue(title, forKey: "title")
        memoManagedObject.setValue(body, forKey: "body")
        memoManagedObject.setValue(lastModified, forKey: "lastModified")
        
        saveContext()
    }
    
    func fetchAll() -> [Memo] {
        let request = Memo.fetchRequest()
        let fetchedMemo = try? context.fetch(request)
        return fetchedMemo ?? []
    }
    
    func delete(memo: Memo) {
        context.delete(memo)
        saveContext()
    }
    
    func update(to memo: Memo, title: String, body: String) {
        let currentDate = Date().timeIntervalSince1970
        memo.setValue(title, forKey: "title")
        memo.setValue(body, forKey: "body")
        memo.setValue(currentDate, forKey: "lastModified")
        saveContext()
    }
    
    func search(for keyword: String) -> [Memo] {
        let request = Memo.fetchRequest()
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", keyword))
        predicates.append(NSPredicate(format: "body CONTAINS[cd] %@", keyword))
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let searchedMemos = try? context.fetch(request)
        
        return searchedMemos ?? []
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
