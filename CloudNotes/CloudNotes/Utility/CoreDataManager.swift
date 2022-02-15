import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetch() -> [Memo] {
        let context = self.persistentContainer.viewContext
        
        do {
            let contact = try context.fetch(Memo.fetchRequest())
            return contact
        } catch {
            fatalError("\(error)")
        }
    }

    func saveContext(memo: TemporaryMemo) {
        let viewContext = self.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Memo", in: viewContext) else {
            return
        }

        let managedObject = NSManagedObject(entity: entity, insertInto: viewContext)
        managedObject.setValue(memo.id, forKey: "id")
        managedObject.setValue(memo.title, forKey: "title")
        managedObject.setValue(memo.body, forKey: "body")
        managedObject.setValue(memo.lastModifiedDate, forKey: "lastModifiedDate")
    
        do {
            try viewContext.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func delete(id: UUID) {
        let viewContext = self.persistentContainer.viewContext
        
        let deleteRequest = NSFetchRequest<Memo>(entityName: "Memo")
        deleteRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            guard let memo = try viewContext.fetch(deleteRequest).first else {
                return
            }
            
            viewContext.delete(memo)
            
            try viewContext.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func deleteAll() {
        let viewContext = self.persistentContainer.viewContext
        
        let deleteAllRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: deleteAllRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
        } catch {
            fatalError("\(error)")
        }
    }
}
