import Foundation
import CoreData

class MemoDataManager {
    static let shared = MemoDataManager()
    private init() {}

    private(set) var memoList = [Memo]()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
}

// MARK: - CRUD
extension MemoDataManager {
    @discardableResult
    func insert(entityName: String = "Memo", items: [String: Any]) -> Memo? {
        let context = persistentContainer.viewContext
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        return update(managedObject, items: items)
    }
    
    @discardableResult
    func fetch(
        entityName: String = "Memo",
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [Memo]? {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = sortDescriptors
        guard let newData = try? context.fetch(request) as? [Memo] else {
            return nil
        }
        memoList = newData
        return newData
    }
    
    @discardableResult
    func update(_ managedObject: NSManagedObject, items: [String: Any]) -> Memo? {
        let keys = managedObject.entity.attributesByName.keys
        for key in keys {
            if let value = items[key] {
                managedObject.setValue(value, forKey: key)
            }
        }
        saveContext()
        fetch()
        return managedObject as? Memo
    }
    
    func delete(_ item: Memo) {
        let context = persistentContainer.viewContext
        let memo = item as NSManagedObject
        context.delete(memo)
        saveContext()
    }

    func createMemo(entityName: String = "Memo", title: String?, body: String?, lastModified: TimeInterval) -> Memo? {
        let managedObject: NSManagedObject = NSEntityDescription.insertNewObject(
            forEntityName: entityName,
            into: persistentContainer.viewContext
        )
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(body, forKey: "body")
        managedObject.setValue(lastModified, forKey: "lastModified")
        return managedObject as? Memo
    }
}
