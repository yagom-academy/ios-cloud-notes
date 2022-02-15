import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchAllRequest() -> NSFetchRequest<Memo> {
        let request = NSFetchRequest<Memo>(entityName: "Memo")
        request.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
        return request
    }

    @NSManaged public var body: String?
    @NSManaged public var lastModified: Int64
    @NSManaged public var title: String?
}
