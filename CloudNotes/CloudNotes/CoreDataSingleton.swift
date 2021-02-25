
import UIKit
import CoreData

class CoreDataSingleton {
    static let shared = CoreDataSingleton()
    
    private init() { }
    
    lazy var memoData: [NSManagedObject] = {
        return self.fetch()
    }()
    
    func fetch() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return [NSManagedObject]()
            // 에러 핸들링 필요
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        
        let result = try! managedContext.fetch(fetchRequest)
        return result
    }
    
    func save(title: String, body: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
            // 에러 핸들링 필요
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: managedContext)
        object.setValue(title, forKey: "title")
        object.setValue(body, forKey: "body")
        object.setValue(Date(), forKey: "lastModified")
        
        do {
            try managedContext.save()
            self.memoData.insert(object, at: 0)
        } catch {
            managedContext.rollback()
        }
    }
    
    func delete(object: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
            // 에러 핸들링 필요
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        managedContext.delete(object)
        
        do {
            try managedContext.save()
        } catch {
            managedContext.rollback()
        }
    }
    
    func update(object: NSManagedObject, title: String, body: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
            // 에러 핸들링 필요
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        object.setValue(title, forKey: "title")
        object.setValue(body, forKey: "body")
        object.setValue(Date(), forKey: "lastModified")
        
        do {
            try managedContext.save()
        } catch {
            managedContext.rollback()
        }
    }
}
