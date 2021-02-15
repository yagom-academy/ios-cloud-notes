import Foundation

struct Memo: Codable {
    var title: String
    var body: String
    var lastModified: Int
    var lastModifiedDate: Date {
        let date = Date(timeIntervalSince1970: TimeInterval(lastModified))
        return date
    }
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
