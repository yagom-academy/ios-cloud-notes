import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "MemoData")
    }

    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var lastModified: Double
    
    convenience init(title: String, body: String, lastModified: TimeInterval) {
        self.init()
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }
}

extension Memo : Identifiable {

}
