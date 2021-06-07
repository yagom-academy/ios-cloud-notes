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
    
    func getUpdatedFileList(completion: (@escaping Handler) = { _ in }) {
        do {
            MemoCache.shared.updatedFileNameList = try context.fetch(UpdatedFile.fetchRequest())
            completion(true)
        } catch {
            completion(false)
            print(DataError.getItems)
        }
    }
    
    func createUpdatedFileListItem(fileName: String, completion: (@escaping Handler) = { _ in }){
        let newItem = UpdatedFile(context: context)
        newItem.name = fileName
        do {
            try context.save()
            getUpdatedFileList()
            completion(true)
        } catch {
            completion(false)
            print(DataError.createItem)
        }
    }

    func deleteUpdatedFileListItem(item: UpdatedFile, completion: (@escaping Handler) = { _ in }) {
        context.delete(item)
        do {
            try context.save()
            getUpdatedFileList()
            completion(true)
        } catch {
            completion(false)
            print(DataError.deleteItem)
        }
    }
    
    func resetUpdatedFileListItem(files: [UpdatedFile], completion: (@escaping Handler) = { _ in }) {
        for file in files {
            context.delete(file)
        }
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
            print(DataError.resetItems)
        }
    }
    
    func convertMemoTypeToMemoListItemType(memoList: [Memo], completion: (@escaping Handler) = { _ in }) {
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
        } catch {
            completion(false)
            print(DataError.convertItem)
        }
    }
    
    // Mark: Function For MemoListItem
    
    func getAllMemoListItems(completion: @escaping Handler = { _ in }) {
        do {
            MemoCache.shared.memoData = try context.fetch(MemoListItem.fetchRequest())
            MemoCache.shared.memoData.reverse()
            completion(true)
        } catch {
            completion(false)
            print(DataError.getItems)
        }
    }
    
    func createMemoListItem(completion: (@escaping Handler) = { _ in }) {
        let newItem = MemoListItem(context: context)
        newItem.title = ""
        newItem.body = ""
        newItem.lastModifiedDate = Date()
        do {
            try context.save()
            getAllMemoListItems()
            completion(true)
        } catch {
            completion(false)
            print(DataError.createItem)
        }
    }

    func updateMemoListItem(item: MemoListItem, completion: (@escaping Handler) = { _ in }) {
  
        item.lastModifiedDate = Date()
        do {
            try context.save()
            getAllMemoListItems()
            completion(true)
        } catch {
            completion(false)
            print(DataError.updateItem)
        }
    }

    func deleteMemoListItem(item: MemoListItem, completion: (@escaping Handler) = { _ in }) {
        context.delete(item)
        do {
            try context.save()
            getAllMemoListItems()
            completion(true)
        } catch {
            completion(false)
            print(DataError.deleteItem)
        }
    }
    
    func resetMemoListItem(items: [MemoListItem], completion: (@escaping Handler) = { _ in }) {
        for item in items {
            context.delete(item)
        }
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
            print(DataError.resetItems)
        }
    }
    
}
