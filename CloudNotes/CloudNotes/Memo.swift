import Foundation

struct Memo: Codable {
    let title: String
    let body: String
    let lastModified: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
