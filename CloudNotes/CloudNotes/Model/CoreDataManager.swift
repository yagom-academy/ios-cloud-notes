import UIKit
import CoreData
 
final class CoreDataManager<T: NSManagedObject> {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var dataList: [T] = []
 
    func create(target: T.Type, attributes: [String: Any]) {
        guard let context = context else {
            return
        }
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: String(describing: T.self),
            in: context
        ) else {
            return
        }
        
        let memo = NSManagedObject(entity: entity, insertInto: context)
        
        attributes.forEach { (key: String, value: Any) in
            memo.setValue(value, forKey: key)
        }
        save()
    }
    
    func fetchAll(request: NSFetchRequest<T>) {
        guard let context = context else {
            return
        }
        
        do {
            self.dataList = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func update(target: T, attributes: [String: Any]) {
        attributes.forEach { (key: String, value: Any) in
            target.setValue(value, forKey: key)
        }
        save()
    }
    
    func delete(target: T) {
        context?.delete(target)
        save()
    }
    
    func save() {
        guard let context = context else { return }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //TODO: SearchController 추후 구현
    //    func search(title: String) -> [Memo]{
    //        let request = NSFetchRequest<Memo>(entityName: "Memo")
    //        let predicate = NSPredicate(format: "title == %@", [title])
    //        request.predicate = predicate
    //        return request
    //    }
}
