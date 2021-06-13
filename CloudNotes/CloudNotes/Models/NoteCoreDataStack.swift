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
    
    private init() { }
    
    // MARK: - Namespaces
    
    private enum CoreDataConstants {
        static let containerName = "CloudNotes"
        static let fetchBatchSize = 20
        
        enum Keys {
            static let lastModified = "lastModified"
        }
    }
    
    // MARK: - Core Data Saving and Loading support

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
    
    func loadSavedNotes(with dataSource: NSFetchedResultsControllerDelegate) {
        if fetchedResultsController == nil {
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            let dateDescendingOrderSort = NSSortDescriptor(key: CoreDataConstants.Keys.lastModified, ascending: false)
            request.sortDescriptors = [dateDescendingOrderSort]
            request.fetchBatchSize = CoreDataConstants.fetchBatchSize
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = dataSource
        }
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            Loggers.data.fault("\(DataError.failedToLoadSavedNotes(error: error))")
        }
    }
}
