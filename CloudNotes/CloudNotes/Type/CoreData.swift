//
//  CoreData.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/05.
//

import Foundation
import UIKit

struct CoreData {
    static let shared = CoreData()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Mark: Function For UpdatedFile
    
    func getUpdatedFileList(completion: (@escaping (Bool) -> (Void))) {
        do {
            MemoCache.shared.updatedFileNameList = try context.fetch(UpdatedFile.fetchRequest())
            print("success getUpdatedFileList")
            completion(true)
        } catch {
            print("error getUpdatedFileList")
            completion(false)
        }
    }
    
    func createUpdatedFileListItem(fileName: String, completion: (@escaping (Bool) -> (Void))) {
        let newItem = UpdatedFile(context: context)
        newItem.name = fileName
        do {
            try context.save()
            getUpdatedFileList(completion: { _ in })
            print("success createUpdatedFileListItem")
            completion(true)
        } catch {
            print("error createUpdatedFileListItem")
            completion(false)
        }
    }

    func deleteUpdatedFileListItem(item: UpdatedFile, completion: (@escaping (Bool) -> (Void))) {
        context.delete(item)
        do {
            try context.save()
            getUpdatedFileList(completion: { _ in })
            print("success deleteUpdatedFileListItem")
            completion(true)
        } catch {
            print("error deleteUpdatedFileListItem")
            completion(false)
        }
    }
    
    func resetUpdatedFileListItem(files: [UpdatedFile], completion: (@escaping (Bool) -> (Void))) {
        for file in files {
            context.delete(file)
        }
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func convertMemoTypeToMemoListItemType(memoList: [Memo], completion: (@escaping (Bool) -> (Void))) {
        for memo in memoList {
            let newItem = MemoListItem(context: context)
            newItem.title = memo.computedTitle
            newItem.body = memo.computedBody
            newItem.lastModifiedDate = Date(timeIntervalSince1970: TimeInterval(memo.computedlastModifiedDate))
        }
        do {
            try context.save()
            getAllMemoListItems(completion: { _ in })
            completion(true)
        } catch {
        }
    }
    
    // Mark: Function For MemoListItem
    
    func getAllMemoListItems(completion: (@escaping (Bool) -> (Void))) {
        do {
            MemoCache.shared.memoData = try context.fetch(MemoListItem.fetchRequest())
            MemoCache.shared.memoData.reverse()
            print("success")
            completion(true)
        } catch {
            print("error")
            completion(false)
        }
    }
    
    func createMemoListItem(completion: (@escaping (Bool) -> (Void))) {
        let newItem = MemoListItem(context: context)
        newItem.title = ""
        newItem.body = ""
        newItem.lastModifiedDate = Date()
        do {
            try context.save()
            getAllMemoListItems(completion: { _ in })
            print("success")
            completion(true)
        } catch {
            print("error")
            completion(false)
        }
    }

    func updateMemoListItem(item: MemoListItem, newTitle: String, newBody: String, completion: (@escaping (Bool) -> (Void))) {
        item.title = newTitle
        item.body = newBody
        item.lastModifiedDate = Date()
        do {
            try context.save()
            getAllMemoListItems(completion: { _ in })
            print("success")
            completion(true)
        } catch {
            print("error")
            completion(false)
        }
    }

    func deleteMemoListItem(item: MemoListItem, completion: (@escaping (Bool) -> (Void))) {
        context.delete(item)
        do {
            try context.save()
            getAllMemoListItems(completion: { _ in })
            print("success")
            completion(true)
        } catch {
            print("error")
            completion(false)
        }
    }
    
    func resetMemoListItem(items: [MemoListItem], completion: (@escaping (Bool) -> (Void))) {
        for item in items {
            context.delete(item)
        }
        do {
            try context.save()
            print("success")
            completion(true)
        } catch {
            print("error")
            completion(false)
        }
    }
    
}
