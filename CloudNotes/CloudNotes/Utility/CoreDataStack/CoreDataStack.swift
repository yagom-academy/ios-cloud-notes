//
//  CoreDataStack.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/09.
//

import CoreData

class CoreDataStack {
    // MARK: Property
    static let modelName = "CloudNotes"
    private let persistentStoreDescription: NSPersistentStoreDescription?
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: CoreDataStack.modelName)
        
        if let persistentStoreDescription = persistentStoreDescription {
            container.persistentStoreDescriptions = [persistentStoreDescription]
        }
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: initializer
    init(persistentStoreDescription: NSPersistentStoreDescription? = nil) {
        self.persistentStoreDescription = persistentStoreDescription
    }
    
    func makeFetchedResultsController<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>, sectionNameKeyPath: String?, cacheName: String?) -> NSFetchedResultsController<T> {
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: managedContext,
                                                    sectionNameKeyPath: sectionNameKeyPath,
                                                    cacheName: cacheName)
        return controller
    }
}
