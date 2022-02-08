import Foundation

struct Sample: Decodable {
    var title: String
    var body: String
    var lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
