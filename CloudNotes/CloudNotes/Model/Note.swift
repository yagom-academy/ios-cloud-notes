import Foundation

struct Note {
    var title: String
    var body: String
    var lastModifiedDate: Date

    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModifiedDate = "last_modified"
    }
}
