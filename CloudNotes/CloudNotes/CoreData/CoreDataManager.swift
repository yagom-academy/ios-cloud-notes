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
    private var storedMemoList: [CloudNote]?

    func retrieveMemoList() -> Result<[Memo], ErrorCases> {
        let cloudNoteFetch = NSFetchRequest<CloudNote>(entityName: Memo.associatedEntity)

        do {
            let entity = try context.fetch(cloudNoteFetch)
            let emptyString = ""

            storedMemoList = entity

            let memoList = entity.map { cloudNote in
                return Memo(
                    title: cloudNote.title ?? emptyString,
                    body: cloudNote.body ?? emptyString,
                    lastUpdatedTime: cloudNote.lastUpdatedTime
                )
            }

            return .success(memoList)
        } catch {
            return .failure(.disabledInFetching)
        }
    }

    func updateMemo(with memo: Memo, at index: Int) -> Bool {
        guard let targetToUpdate = storedMemoList?[index] else {
            return false
        }

        targetToUpdate.title = memo.title
        targetToUpdate.body = memo.body
        targetToUpdate.lastUpdatedTime = memo.lastUpdatedTime

        do {
            try context.save()
            return true
        } catch {
            return false
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

    enum ErrorCases: LocalizedError {
        case disabledInParsing
        case disabledInFetching

        var errorDescription: String? {
            switch self {
            case .disabledInParsing:
                return "Error: Failed to parsing, I want to report this!"
            case .disabledInFetching:
                return "Error: Failed to fetch, I don't know what to do..."
            }
        }
    }
}
