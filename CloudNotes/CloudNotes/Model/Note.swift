import Foundation

struct Note: Decodable, Hashable {
    
    var identifier: UUID?
    let title: String
    let body: String
    let lastModified: Date
    
}
