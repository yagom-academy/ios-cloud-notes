import UIKit
import CoreData
 
final class CoreDataManager<T: NSManagedObject>: DataProvider {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    lazy var fetchedController = createNoteFetchedResultsController()
    
    func create(attributes: [String: Any]) {
        createCoreData(target: T.self, attributes: attributes)
    }
    
    func read(index: IndexPath) -> MemoType? {
        return fetchedController.object(at: index) as? MemoType
    }
    
    func update(target: MemoType, attributes: [String: Any]) {
        guard let target = target as? T else {
            return
        }
        updateCoreData(target: target, attributes: attributes)
    }
    
    func delete(target: MemoType) {
        let finder = find(identifier: target.identifier?.uuidString ?? "")
        let data = finder.object(at: IndexPath(row: 0, section: 0))
        do {
            try fetchedController.performFetch()
        } catch {
            
        }
        deleteCoreData(target: data)
    }
    
    func countAllData() -> Int {
        fetchedController.sections?[0].numberOfObjects ?? .zero
    }
    
    private func createCoreData(target: T.Type, attributes: [String: Any]) {
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
    
    private func updateCoreData(target: T, attributes: [String: Any]) {
        attributes.forEach { (key: String, value: Any) in
            target.setValue(value, forKey: key)
        }
        target.setValue(Date(), forKey: "lastModified")
        save()
    }
    
    private func deleteCoreData(target: T) {
        context?.delete(target)
        save()
    }
    
    private func save() {
        guard let context = context else { return }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func find(identifier query: String) -> NSFetchedResultsController<T> {
        guard let context = context else {
            return NSFetchedResultsController()
        }
        
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
            return NSFetchedResultsController()
        }
        
        let sortDescriptor = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "identifier = %@", query)
        fetchRequest.predicate = predicate
    
         let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch {
            
        }
        
        return controller
    }
    
    private func createNoteFetchedResultsController(query: String? = nil) -> NSFetchedResultsController<T> {
        guard let context = context else {
            return NSFetchedResultsController()
        }
        
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
            return NSFetchedResultsController()
        }
        
        let sortDescriptor = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let query = query {
            let predicate = NSPredicate(format: "text contains[cd] %@", query)
            fetchRequest.predicate = predicate
        }
        
        let fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedController.performFetch()
        } catch {
            
        }
        return fetchedController
    }
}
