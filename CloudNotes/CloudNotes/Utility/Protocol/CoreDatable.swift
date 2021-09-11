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
    
    func deleteItem(object: NSManagedObject) {
        context.delete(object)
    }
    
    func updateItem(_ item: NSManagedObject, handler: (NSManagedObject) -> Void) {
        handler(item)
        contextSave()
    }
}
