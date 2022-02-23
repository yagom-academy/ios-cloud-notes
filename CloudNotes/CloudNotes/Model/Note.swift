import Foundation

struct Note: Decodable, Hashable {
    
    var identifier: UUID
    let title: String
    let body: String
    let lastModified: Date
    
}

extension Note {
    
    init(cdNote: CDNote) {
        self.identifier = cdNote.identifier
        self.title = cdNote.title ?? ""
        self.body = cdNote.body ?? ""
        self.lastModified = cdNote.lastModified
    }
    
}
