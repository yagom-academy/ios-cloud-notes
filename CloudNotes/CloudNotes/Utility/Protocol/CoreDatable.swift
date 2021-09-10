//
//  CoreDatable.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import CoreData

protocol CoreDatable {
    var context: NSManagedObjectContext { get }
    
    func contextSave()
    func createItem<T: NSManagedObject>(_ item: T?)
    func deleteItem(object: NSManagedObject)
    func updateItem(_ item: NSManagedObject, handler: (NSManagedObject) -> Void)
}

extension CoreDatable {
    func contextSave() {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            context.rollback()
        }
        
    }
    
    func createItem<T: NSManagedObject>(_ item: T?) {
        guard let item = item else { return }
        
        context.insert(item)
    }
    
    func deleteItem(object: NSManagedObject) {
        context.delete(object)
    }
    
    func updateItem(_ item: NSManagedObject, handler: (NSManagedObject) -> Void) {
        handler(item)
        contextSave()
    }
}
