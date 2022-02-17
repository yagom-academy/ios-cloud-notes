import Foundation
import CoreData

class PersistentDataManager {
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func create(entity name: String, handler: ((NSManagedObject) -> Void)? = nil) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else {
            return
        }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        handler?(managedObject)
        try context.save()
    }
    
    func fetch<T>(request: NSFetchRequest<T>) throws -> [T] {
        try context.fetch(request)
    }
    
    func update<T: NSManagedObject>(request: NSFetchRequest<T>, handler: ((NSManagedObject) -> Void)? = nil) throws {
        let filteredResults = try context.fetch(request)
        guard let filteredResult = filteredResults.first else {
            return
        }
        
        handler?(filteredResult)
        try context.save()
    }
    
    func delete<T: NSManagedObject>(request: NSFetchRequest<T>, handler: ((NSManagedObject) -> Void)? = nil) throws {
        let filteredResults = try context.fetch(request)
        guard let filteredResult = filteredResults.first else {
            return
        }
        
        context.delete(filteredResult)
        try context.save()
    }
    
}
