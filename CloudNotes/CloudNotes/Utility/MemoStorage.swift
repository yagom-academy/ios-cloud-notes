//
//  MemoStorage.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/11.
//

import CoreData

class MemoStorage {
    lazy var context = persistentContainer.newBackgroundContext()
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CloudNotes")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("persistent stores 로드에 실패했습니다 : \(error)")
            }
        }
        return container
    }()
    
    func create() {
        guard let memoEntity = NSEntityDescription.entity(forEntityName: "Memo", in: context) else {
            return
        }
        
        let memoManagedObject = NSManagedObject(entity: memoEntity, insertInto: context)
        
        memoManagedObject.setValue(UUID(), forKey: "id")
        memoManagedObject.setValue("", forKey: "title")
        memoManagedObject.setValue("", forKey: "body")
        memoManagedObject.setValue(Date().timeIntervalSince1970, forKey: "lastModified")
        
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
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
