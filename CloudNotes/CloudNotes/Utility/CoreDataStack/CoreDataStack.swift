//
//  CoreDataStack.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/09.
//

import CoreData

final class CoreDataStack {
    // MARK: Property
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
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
    private init() { }

    func makeFetchedResultsController<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>, sectionNameKeyPath: String?, cacheName: String?) -> NSFetchedResultsController<T> {
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: managedContext,
                                                    sectionNameKeyPath: sectionNameKeyPath,
                                                    cacheName: cacheName)
        return controller
    }
}
