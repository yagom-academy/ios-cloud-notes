import Foundation

struct Note: Decodable, Hashable {
    
    var identifier: UUID
    let title: String
    let body: String
    let lastModified: Date
    
}

extension Note {
    
    static func convertToNote(from cdNote: CDNote) -> Note {
        return Note(
            identifier: cdNote.identifier,
            title: cdNote.title ?? "",
            body: cdNote.body ?? "",
            lastModified: cdNote.lastModified)
    }
    
}
