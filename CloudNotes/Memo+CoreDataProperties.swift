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
//    convenience init (title: String?, body: String?, lastModifiedDate: Double, memoId: UUID?) {
//        self.init()
//        self.title = title
//        self.body = body
//        self.lastModifiedDate = lastModifiedDate
//        self.memoId = memoId
//    }
}
