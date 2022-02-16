import Foundation
import CoreData

extension Memo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var body: String?
    @NSManaged public var lastModified: Double
    @NSManaged public var title: String?

    var convertedDate: String {
        let dateFormatter = DateFormatter.shared
        let currentDate = Date(timeIntervalSince1970: lastModified)
        
        return dateFormatter.string(from: currentDate)
    }
    
    var entireContent: String {
        let title = title ?? ""
        if let body = body {
            return "\(title)\n\(body)"
        } else {
            return title
        }
    }
}
