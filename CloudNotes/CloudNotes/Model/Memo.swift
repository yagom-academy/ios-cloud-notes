import Foundation

struct Memo: Decodable {
    var title: String
    var body: String
    private var lastModified: Int
    var lastModifiedDate: String {
        let dateStr = Date(timeIntervalSince1970: TimeInterval(lastModified)).convertToString()
        return dateStr
    }
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
