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
    
    // MARK: - Core Data Saving support
    func saveContext () {
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
    
    func create(identifier: UUID, title: String, body: String, lastModified: Date) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CDNote", in: context)
        
        if let entity = entity {
            let note = NSManagedObject(entity: entity, insertInto: context)
            
            note.setValue(identifier, forKey: "identifier")
            note.setValue(title, forKey: "title")
            note.setValue(body, forKey: "body")
            note.setValue(lastModified, forKey: "lastModified")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetch<T>(request: NSFetchRequest<T>) -> [T] {
        let context = persistentContainer.viewContext
        
        do {
            let note = try context.fetch(request)
            return note
        } catch {
            return []
        }
    }
    
}
