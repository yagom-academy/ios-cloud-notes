//
//  MemoModel.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/15.
//

import UIKit
import CoreData

class MemoModel {
    static let shared = MemoModel()
    private init() {}
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var list: [Memo] = [] {
        didSet {
            toggleAddButton()
        }
    }
    
    func fetch() {
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        let sort = NSSortDescriptor(key: "registerDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            self.list = try context?.fetch(fetchRequest) as! [Memo]
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func create(content: String?) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return
        }

        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: context)
        object.setValue(content, forKey: "content")
        object.setValue(Date(), forKey: "registerDate")
        guard let memoObject = object as? Memo else {
            return
        }
        
        do {
            try context.save()
            self.list.insert(memoObject, at: self.list.startIndex)
            NotificationCenter.default.post(name: .createMemo, object: self, userInfo: ["index": 0])
        } catch  {
            context.rollback()
        }
    }
    
    func update(index: Int, content: String?) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return
        }
        
        let object = list[index]
        object.setValue(content, forKey: "content")
        object.setValue(Date(), forKey: "registerDate")
        
        do {
            try context.save()
            self.list.remove(at: index)
            self.list.insert(object, at: self.list.startIndex)
            NotificationCenter.default.post(name: .updateMemo, object: self, userInfo: ["index": index])
        } catch {
            context.rollback()
        }
    }
    
    func delete(index: Int) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return
        }
        context.delete(list[index])
        
        do {
            try context.save()
            self.list.remove(at: index)
            NotificationCenter.default.post(name: .deleteMemo, object: self, userInfo: ["index": index])
        } catch {
            context.rollback()
        }
    }
    
    private func toggleAddButton() {
        if let newMemo = self.list.first {
            if let _ = newMemo.content {
                NotificationCenter.default.post(name: .enableAddButton, object: self)
            } else {
                NotificationCenter.default.post(name: .disableAddButton, object: self)
            }
        } else {
            NotificationCenter.default.post(name: .enableAddButton, object: self)
        }
    }
}
