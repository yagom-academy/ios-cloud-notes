import UIKit
import CoreData

class DataStorage {
    var assetData: [Sample] {
        return JSONParser.decodeData(of: "sample", how: [Sample].self) ?? [Sample(title: "", body: "", lastModified: .zero)]
    }
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveMemoInContext(title: String, body: String, lastModified: Int64) {
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
}
