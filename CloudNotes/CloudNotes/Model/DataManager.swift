import UIKit
import CoreData

protocol CoreDataProvidable {
    associatedtype Entity: NSManagedObject
    var dataList: [Entity] { get set }
    
    func provideIntialData(request: NSFetchRequest<Entity>) -> [Entity]
    func create(target: Entity, attributes: [String: Any])
    func fetchAll(request: NSFetchRequest<Entity>)
    func update(target: Entity, attributes: [String: Any])
    func delete(target: Entity)
    func save()
}

final class DataManager<T: NSManagedObject>: CoreDataProvidable {
    typealias Entity = T
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    internal var dataList: [Entity] = []
    
    func provideIntialData(request: NSFetchRequest<Entity>) -> [Entity] {
        fetchAll(request: request)
        return dataList
    }
    
    func create(target: Entity, attributes: [String: Any]) {
        guard let context = context else { return }
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: String(describing: Entity.self),
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
    
    func fetchAll(request: NSFetchRequest<Entity>) {
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
    
    func update(target: Entity, attributes: [String: Any]) {
        attributes.forEach { (key: String, value: Any) in
            target.setValue(value, forKey: key)
        }
        let time = extractCurrentDate()
        target.setValue(time, forKey: "lastModified")
        save()
    }
    
    func delete(target: Entity) {
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
    
    private func extractCurrentDate() -> Int {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return Int(dateFormatter.string(from: date)) ?? .zero
    }
    
    //TODO: SearchController 추후 구현
    //    func search(title: String) -> [Memo]{
    //        let request = NSFetchRequest<Memo>(entityName: "Memo")
    //        let predicate = NSPredicate(format: "title == %@", [title])
    //        request.predicate = predicate
    //        return request
    //    }
}
