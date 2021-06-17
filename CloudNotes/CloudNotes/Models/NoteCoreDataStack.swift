//
//  NoteManager.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/11.
//

import CoreData
import os

final class NoteCoreDataStack {
    
    // MARK: - Properties
    
    static let shared = NoteCoreDataStack()
    private(set) var fetchedResultsController: NSFetchedResultsController<Note>?
    lazy private(set) var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: CoreDataConstants.containerName)
        container.loadPersistentStores { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error as NSError? {
                Loggers.data.fault("\(DataError.failedToLoadPersistentStores(error: error))")
            }
        }
        return container
    }()
    
    // MARK: - Initializer (Set as private due to having shared instance)
    
    private init() { }
    
    // MARK: - Namespaces
    
    enum CoreDataConstants {
        static let containerName = "CloudNotes"
        static let fetchBatchSize = 20
        
        enum Keys {
            static let lastModified = "lastModified"
        }
    }
}

extension NoteCoreDataStack: CoreDataStack {
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                Loggers.data.fault("\(DataError.failedToSave(error: error))")
            }
        }
    }
    
    /// If fetchedResultsController is not implemented, this initializes fetched results controller and set the passed argument as fetched results controller delegate.
    func loadSavedNotes(with noteManager: NSFetchedResultsControllerDelegate) {
        if fetchedResultsController == nil {
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            let dateDescendingOrderSort = NSSortDescriptor(key: CoreDataConstants.Keys.lastModified, ascending: false)
            request.sortDescriptors = [dateDescendingOrderSort]
            request.fetchBatchSize = CoreDataConstants.fetchBatchSize
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = noteManager
        }
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            Loggers.data.fault("\(DataError.failedToLoadSavedNotes(error: error))")
        }
    }
}
