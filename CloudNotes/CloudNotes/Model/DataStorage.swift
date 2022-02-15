import UIKit
import CoreData

class DataStorage {
    var assetData: [Sample] {
        return JSONParser.decodeData(of: "sample", how: [Sample].self) ?? [Sample(title: "", body: "", lastModified: .zero)]
    }
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func extractCurrentDate() -> Int {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return Int(dateFormatter.string(from: date)) ?? .zero
    }
    
    func create(title: String, body: String, lastModified: Int64) {
        guard let context = context else { return }
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: "Memo",
            in: context
        ) else {
            return
        }

        let memo = NSManagedObject(entity: entity, insertInto: context)
        memo.setValue(title, forKey: "title")
        memo.setValue(body, forKey: "body")
        memo.setValue(lastModified, forKey: "lastModified")

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func update(target: Memo, title: String?, body: String?) {
        if title != nil {
            target.setValue(title, forKey: "title")
        }
        
        if body != nil {
            target.setValue(body, forKey: "body")
        }
        let time = extractCurrentDate()
        
        target.setValue(time, forKey: "lastModified")
        
    }
    
    func fetchAll() -> [Memo]? {
        guard let context = context else {
            return nil
        }
        
        do {
            let memos = try context.fetch(Memo.fetchAllRequest())
            return memos
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func delete(target: Memo) {
        context?.delete(target)
        
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
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
