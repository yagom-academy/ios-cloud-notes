//
//  MemoModel.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit
import CoreData

class MemoModel {
    static let shared = MemoModel()
    private init() {}
    
    var list: [Memo] = []
    
    func save(title: String?, body: String?) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.saveMemo
        }
        let context = appDelegate.persistentContainer.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(body, forKey: "body")
        object.setValue(Date(), forKey: "lastModified")
        guard let memoObject = object as? Memo else {
            throw MemoError.saveMemo
        }
        
        do {
            try context.save()
            self.list.insert(memoObject, at: self.list.startIndex)
        } catch {
            context.rollback()
            throw error
        }
    }
    
    func fetch() throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.fetchMemo
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        let sort = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            let result = try context.fetch(fetchRequest)
            guard let memoObjectList = result as? [Memo] else {
                throw MemoError.fetchMemo
            }
            self.list = memoObjectList
        } catch {
            throw error
        }
    }
    
    func delete(index: Int) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.deleteMemo
        }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(list[index])
        do {
            try context.save()
            self.list.remove(at: index)
        } catch {
            context.rollback()
            throw MemoError.deleteMemo
        }
    }
    
    func update(index: Int, title: String, body: String?) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.updateMemo
        }
        let context = appDelegate.persistentContainer.viewContext
        let object = list[index]
        object.setValue(title, forKey: "title")
        object.setValue(body, forKey: "body")
        object.setValue(Date(), forKey: "lastModified")        
        do {
            try context.save()
            self.list.remove(at: index)
            self.list.insert(object, at: self.list.startIndex)
        } catch {
            context.rollback()
            throw MemoError.updateMemo
        }
    }
}
