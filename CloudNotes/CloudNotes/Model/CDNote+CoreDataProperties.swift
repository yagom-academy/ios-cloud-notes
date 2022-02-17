import Foundation
import CoreData

extension CDNote {

    @nonobjc public class func fetchNoteRequest() -> NSFetchRequest<CDNote> {
        return NSFetchRequest<CDNote>(entityName: "CDNote")
    }
    
    @nonobjc public class func fetchNoteRequest(with identifier: UUID) -> NSFetchRequest<CDNote> {
        let fetchRequest = CDNote.fetchNoteRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier.uuidString)
        return fetchRequest
    }
    
    @nonobjc public class func fetchSortedNoteRequest() -> NSFetchRequest<CDNote> {
        let fetchRequest = CDNote.fetchNoteRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: true)]
        return fetchRequest
    }

    @NSManaged public var body: String?
    @NSManaged public var identifier: UUID?
    @NSManaged public var lastModified: Date?
    @NSManaged public var title: String?

}
