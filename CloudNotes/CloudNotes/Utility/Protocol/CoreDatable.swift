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
    func deleteItem(objectID: NSManagedObjectID)
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
    
    func deleteItem(objectID: NSManagedObjectID) {
        context.object(with: objectID)
    }
    
    func updateItem(_ item: NSManagedObject, handler: (NSManagedObject) -> Void) {
        handler(item)
        contextSave()
    }
}
