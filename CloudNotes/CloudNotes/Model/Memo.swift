import Foundation

struct Memo: Codable {
    let title, body: String
    let lastModified: Int

    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
