//
//  NoteManager.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/11.
//

import CoreData
import OSLog

final class NoteCoreDataManager {
    // MARK: - Properties
    
    static let shared = NoteCoreDataManager()
    private var fetchedResultsController: NSFetchedResultsController<Note>?
    var fetchedNotes: [Note] {
        return fetchedResultsController?.fetchedObjects ?? []
    }
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: CoreDataConstants.containerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error as NSError? {
                os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToSave(error: error).localizedDescription)
            }
        })
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
                os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToSave(error: error).localizedDescription)
            }
        }
    }
    
    func loadSavedNotes(with viewController: NSFetchedResultsControllerDelegate) {
        if fetchedResultsController == nil {
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            let dateDescendingOrderSort = NSSortDescriptor(key: CoreDataConstants.Keys.lastModified, ascending: false)
            request.sortDescriptors = [dateDescendingOrderSort]
            request.fetchBatchSize = CoreDataConstants.fetchBatchSize
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = viewController
        }
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToLoadSavedNotes(error: error).localizedDescription)
        }
    }
}
