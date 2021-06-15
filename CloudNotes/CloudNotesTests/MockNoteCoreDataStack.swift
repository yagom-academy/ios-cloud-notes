//
//  MockNoteCoreDataStack.swift
//  CloudNotesTests
//
//  Created by Ryan-Son on 2021/06/14.
//

import CoreData
import os
@testable import CloudNotes

final class MockNoteCoreDataStack: CoreDataStack {
    
    private(set) var fetchedResultsController: NSFetchedResultsController<Note>?
    lazy private(set) var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: NoteCoreDataStack.CoreDataConstants.containerName)
        container.loadPersistentStores { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error as NSError? {
                fatalError("\(DataError.failedToLoadPersistentStores(error: error))")
            }
        }
        return container
    }()
    
    init() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        guard let note = NSManagedObjectModel.mergedModel(from: nil) else {
            fatalError("Could not load model")
        }
        
        let container = NSPersistentCloudKitContainer(name: NoteCoreDataStack.CoreDataConstants.containerName, managedObjectModel: note)
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("\(DataError.failedToLoadPersistentStores(error: error))")
            }
        }
        
        persistentContainer = container
    }
    
    // MARK: - Core Data Saving and Loading support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("\(DataError.failedToSave(error: error))")
            }
        }
    }
    
    /// If fetchedResultsController is not implemented, this initializes fetched results controller and set the passed argument as fetched results controller delegate.
    func loadSavedNotes(with noteManager: NSFetchedResultsControllerDelegate) {
        if fetchedResultsController == nil {
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            let dateDescendingOrderSort = NSSortDescriptor(key: NoteCoreDataStack.CoreDataConstants.Keys.lastModified, ascending: false)
            request.sortDescriptors = [dateDescendingOrderSort]
            request.fetchBatchSize = NoteCoreDataStack.CoreDataConstants.fetchBatchSize
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = noteManager
        }
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            fatalError("\(DataError.failedToLoadSavedNotes(error: error))")
        }
    }
}
