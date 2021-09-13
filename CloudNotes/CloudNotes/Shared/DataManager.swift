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

    func add(memo: String) {
        let newMemo = MemoEntity(context: mainContext)
        newMemo.content = memo
        newMemo.insertData = Date()
        saveContext()

        memoList.insert(newMemo, at: 0)
    }

    func fetch() {
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: "insertDate", ascending: false)]

        do {
            memoList = try mainContext.fetch(request)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func update(memo: String, entity: MemoEntity?) {
        entity?.content = memo
        saveContext()
    }

    func delete(memo: MemoEntity?) {
        if let memo = memo {
            mainContext.delete(memo)

            if let index = memoList.firstIndex(of: memo) {
                memoList.remove(at: index)
            }
        }
        saveContext()
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
