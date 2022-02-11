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
    
    func create(with memo: Memo) {
        guard let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: context) else {
            return
        }
        
        let noteManagedObject = NSManagedObject(entity: noteEntity, insertInto: context)
        
        noteManagedObject.setValue(memo.id, forKey: "id")
        noteManagedObject.setValue(memo.title, forKey: "title")
        noteManagedObject.setValue(memo.body, forKey: "body")
        noteManagedObject.setValue(memo.lastModified, forKey: "lastModified")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
