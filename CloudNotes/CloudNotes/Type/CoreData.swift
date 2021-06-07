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
    
    func getUpdatedFileList() {
        do {
            MemoCache.shared.updatedFileNameList = try context.fetch(UpdatedFile.fetchRequest())
        } catch {
            print(DataError.getItems)
        }
    }
    
    func createUpdatedFileListItem(fileName: String){
        let newItem = UpdatedFile(context: context)
        newItem.name = fileName
        do {
            try context.save()
            getUpdatedFileList()
        } catch {
            print(DataError.createItem)
        }
    }

    func deleteUpdatedFileListItem(item: UpdatedFile) {
        context.delete(item)
        do {
            try context.save()
            getUpdatedFileList()
        } catch {
            print(DataError.deleteItem)
        }
    }
    
    func resetUpdatedFileListItem(files: [UpdatedFile]) {
        for file in files {
            context.delete(file)
        }
        do {
            try context.save()
        } catch {
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
        } catch {
            print(DataError.convertItem)
        }
    }
    
    // Mark: Function For MemoListItem
    
    func getAllMemoListItems() {
        do {
            MemoCache.shared.memoData = try context.fetch(MemoListItem.fetchRequest())
            MemoCache.shared.memoData.reverse()
        } catch {
            print(DataError.getItems)
        }
    }
    
    func createMemoListItem() {
        let newItem = MemoListItem(context: context)
        newItem.title = ""
        newItem.body = ""
        newItem.lastModifiedDate = Date()
        do {
            try context.save()
            getAllMemoListItems()
        } catch {
            print(DataError.createItem)
        }
    }

    func updateMemoListItem(item: MemoListItem) {
  
        item.lastModifiedDate = Date()
        do {
            try context.save()
            getAllMemoListItems()
        } catch {
            print(DataError.updateItem)
        }
    }

    func deleteMemoListItem(item: MemoListItem) {
        context.delete(item)
        do {
            try context.save()
            getAllMemoListItems()
        } catch {
            print(DataError.deleteItem)
        }
    }
    
    func resetMemoListItem(items: [MemoListItem]) {
        for item in items {
            context.delete(item)
        }
        do {
            try context.save()
        } catch {
            print(DataError.resetItems)
        }
    }
    
}
