import UIKit
import CoreData

class CoreDataSingleton {
    static let shared = CoreDataSingleton()
    
    private init() { }
    
    lazy var memoData: [NSManagedObject] = {
        return self.fetch()
    }()
    
    func fetch() -> [NSManagedObject] {
        var fetchData: [NSManagedObject] = [NSManagedObject]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return [NSManagedObject]()
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        let sort = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            if let result: [NSManagedObject] = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                fetchData = result
            }
        } catch {
            print(MemoAppSystemError.unkowned)
        }
        return fetchData
    }
    
    func save(content: String) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoAppSystemError.unkowned
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: managedContext)
        object.setValue(content, forKey: "content")
        object.setValue(Date(), forKey: "lastModified")
        
        do {
            try managedContext.save()
            self.memoData.insert(object, at: 0)
        } catch {
            managedContext.rollback()
            throw MemoAppSystemError.saveFailed
        }
    }
    
    func delete(object: NSManagedObject) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoAppSystemError.unkowned
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        managedContext.delete(object)
        
        do {
            try managedContext.save()
        } catch {
            managedContext.rollback()
            throw MemoAppSystemError.deleteFailed
        }
    }
    
    func update(object: NSManagedObject, content: String) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoAppSystemError.unkowned
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        object.setValue(content, forKey: "content")
        object.setValue(Date(), forKey: "lastModified")
        
        do {
            try managedContext.save()
        } catch {
            managedContext.rollback()
            throw MemoAppSystemError.updateFailed
        }
    }
}
