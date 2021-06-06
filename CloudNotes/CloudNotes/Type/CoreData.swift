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
    
    func getAllItems(completion: (@escaping (Bool) -> (Void))) {
        do {
            MemoCache.shared.decodedJsonData = try context.fetch(MemoListItem.fetchRequest()) as! [Memo]
            print("success")
            completion(true)
        } catch {
            print("error")
            completion(false)
        }
    }
    
    func createItem(completion: (@escaping (Bool) -> (Void))) {
        let newItem = MemoListItem(context: context)
        newItem.title = "111"
        newItem.body = "222"
        newItem.lastModifiedDate = Date()
        do {
            try context.save()
            getAllItems(completion: { _ in })
            print("success")
            completion(true)
        } catch {
            print("error")
            completion(false)
        }
    }

    func updateItem(item: MemoListItem, newTitle: String, newBody: String) {
        item.title = newTitle
        item.body = newBody
        item.lastModifiedDate = Date()
        do {
            try context.save()
            getAllItems(completion: { _ in })
        } catch {
        }
    }

    func deleteItem(item: MemoListItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems(completion: { _ in })
        } catch {

        }
    }
}
