//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/15.
//

import Foundation
import CoreData

final class CoreDataManager {
    private var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()
    private lazy var context = persistentContainer.viewContext
    var storedMemoList: [CloudNote]?

    func retrieveMemoList() -> [Memo] {
        let cloudNoteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Memo.associatedEntity)

        do {
            if let entity = try context.fetch(cloudNoteFetch) as? [CloudNote] {
                storedMemoList = entity

                let emptyString = ""

                return entity.map { cloudNote in
                    Memo(
                        title: cloudNote.title ?? emptyString,
                        body: cloudNote.body ?? emptyString,
                        lastUpdatedTime: cloudNote.lastUpdatedTime
                    )
                }
            } else {
                fatalError("Error: Fail to cast memo from Any")
            }
        } catch {
            fatalError("Error: Context can not execute about FetchRequest")
        }
    }

    func createMemo(with memo: Memo) -> Bool {
        let entity = NSEntityDescription.insertNewObject(forEntityName: Memo.associatedEntity, into: context)

        entity.setValue(memo.title, forKey: Memo.CoreDataKey.title.rawValue)
        entity.setValue(memo.body, forKey: Memo.CoreDataKey.body.rawValue)
        entity.setValue(memo.lastUpdatedTime, forKey: Memo.CoreDataKey.lastUpdatedTime.rawValue)

        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
