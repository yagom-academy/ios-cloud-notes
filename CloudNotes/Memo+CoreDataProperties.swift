import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var lastModified: Double

}

extension Memo : Identifiable {

}
