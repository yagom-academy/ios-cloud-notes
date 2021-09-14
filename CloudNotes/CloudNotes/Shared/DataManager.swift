//
//  DataManager.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/13.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Memo")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var memoList = [MemoEntity]()

}

// MARK: - CRUD
extension DataManager {
    func addNewMemo(_ memo: String) {
        let newMemo = MemoEntity(context: mainContext)
        newMemo.content = memo
        newMemo.insertData = Date()
        memoList.insert(newMemo, at: 0)

        saveContext()
    }

    func fetchMemo() {
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDate]

        do {
            memoList = try mainContext.fetch(request)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func updateMemo(_ memo: String, _ entity: MemoEntity?) {
        if let entity = entity {
            entity.content = memo
            saveContext()
        }
    }

    func deleteMemo(_ memo: MemoEntity?) {
        if let memo = memo {
            mainContext.delete(memo)
            saveContext()
        }
    }
}

extension DataManager {
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
