import Foundation
import CoreData

class CoreDataManager {
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetch<Element: NSManagedObject>(_ request: NSFetchRequest<Element>) -> [Element]? {
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "lastModifiedDate", ascending: false)]
            let elements = try context.fetch(request)
            return elements
        } catch {
            fatalError("\(error)")
        }
    }

    func saveContext(memo: TemporaryMemo) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Memo", in: context) else {
            return
        }

        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(memo.memoId, forKey: "memoId")
        managedObject.setValue(memo.title, forKey: "title")
        managedObject.setValue(memo.body, forKey: "body")
        managedObject.setValue(memo.lastModifiedDate, forKey: "lastModifiedDate")
    
        do {
            try context.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func updateMemo(_ memo: Memo) {
        let request: NSFetchRequest<Memo> = NSFetchRequest<Memo>(entityName: "Memo")
        guard let memoId = memo.memoId else {
            return
        }
        
        request.predicate = NSPredicate(format: "memoId = %@", memoId.uuidString)
        
        do {
            let memoToUpdate = try context.fetch(request)
            
            let managedObject = memoToUpdate.first
            managedObject?.setValue(memo.title, forKey: "title")
            managedObject?.setValue(memo.body ?? "", forKey: "body")
            managedObject?.setValue(memo.lastModifiedDate, forKey: "lastModifiedDate")
            
            try context.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func updateMemo(_ memo: TemporaryMemo) {
        let request: NSFetchRequest<Memo> = NSFetchRequest<Memo>(entityName: "Memo")
        
        request.predicate = NSPredicate(format: "memoId = %@", memo.memoId.uuidString)
        
        do {
            let memoToUpdate = try context.fetch(request)
            
            let managedObject = memoToUpdate.first
            managedObject?.setValue(memo.title, forKey: "title")
            managedObject?.setValue(memo.body ?? "", forKey: "body")
            managedObject?.setValue(memo.lastModifiedDate, forKey: "lastModifiedDate")
            
            try context.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func delete<Element: NSManagedObject>(request: NSFetchRequest<Element>) {
        do {
            let elementsToDelete = try context.fetch(request)
            
            elementsToDelete.forEach { element in
                context.delete(element)
            }
            
            try context.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func deleteMemo(memoId: UUID?) {
        guard let memoId = memoId else {
            return
        }

        let deleteRequest = Memo.fetchRequest()
        deleteRequest.predicate = NSPredicate(format: "memoId = %@", memoId.uuidString)
        
        delete(request: deleteRequest)
    }
    
    func deleteAll() {
        let deleteAllRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: deleteAllRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            fatalError("\(error)")
        }
    }
}
