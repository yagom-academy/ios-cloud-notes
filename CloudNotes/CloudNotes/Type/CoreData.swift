//
//  CoreData.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/05.
//

import Foundation
import UIKit
typealias Handler = (Bool) -> Void
struct CoreData {
    static let shared = CoreData()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Mark: Function For UpdatedFile
    
    func getUpdatedFileList(completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
        do {
            MemoCache.shared.updatedFileNameList = try context.fetch(UpdatedFile.fetchRequest())
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.getItems)
        }
    }
    
    func createUpdatedFileListItem(fileName: String, completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
        let newItem = UpdatedFile(context: context)
        newItem.name = fileName
        do {
            try context.save()
            getUpdatedFileList()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.createItem)
        }
    }

    func deleteUpdatedFileListItem(item: UpdatedFile, completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
        context.delete(item)
        do {
            try context.save()
            getUpdatedFileList()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.deleteItem)
        }
    }
    
    func resetUpdatedFileListItem(files: [UpdatedFile], completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
        for file in files {
            context.delete(file)
        }
        do {
            try context.save()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.resetItems)
        }
    }
    
    func convertMemoTypeToMemoListItemType(memoList: [Memo], completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
        for memo in memoList {
            let newItem = MemoListItem(context: context)
            newItem.title = memo.computedTitle
            newItem.body = memo.computedBody
            newItem.lastModifiedDate = Date(timeIntervalSince1970: TimeInterval(memo.computedlastModifiedDate))
        }
        do {
            try context.save()
            getAllMemoListItems()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.convertItem)
        }
    }
    
    // Mark: Function For MemoListItem
    
    func getAllMemoListItems(completion: @escaping Handler = { _ in }) -> Result<Void?, DataError> {
        do {
            MemoCache.shared.memoData = try context.fetch(MemoListItem.fetchRequest())
            MemoCache.shared.memoData.reverse()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.getItems)
        }
    }
    
    func createMemoListItem(completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
        let newItem = MemoListItem(context: context)
        newItem.title = ""
        newItem.body = ""
        newItem.lastModifiedDate = Date()
        do {
            try context.save()
            getAllMemoListItems()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.createItem)
        }
    }

    func updateMemoListItem(item: MemoListItem, completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
  
        item.lastModifiedDate = Date()
        do {
            try context.save()
            getAllMemoListItems()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.updateItem)
        }
    }

    func deleteMemoListItem(item: MemoListItem, completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
        context.delete(item)
        do {
            try context.save()
            getAllMemoListItems()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.deleteItem)
        }
    }
    
    func resetMemoListItem(items: [MemoListItem], completion: (@escaping Handler) = { _ in }) -> Result<Void?, DataError> {
        for item in items {
            context.delete(item)
        }
        do {
            try context.save()
            completion(true)
            return .success(nil)
        } catch {
            completion(false)
            return .failure(DataError.resetItems)
        }
    }
    
}
