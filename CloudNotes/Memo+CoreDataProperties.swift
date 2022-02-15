import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var body: String?
    @NSManaged public var memoId: UUID?
    @NSManaged public var lastModifiedDate: Double
    @NSManaged public var title: String?

}

extension Memo : Identifiable {

}
