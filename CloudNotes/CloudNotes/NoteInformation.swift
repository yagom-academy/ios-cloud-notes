import Foundation

struct NoteInformation: Decodable {
    let title: String
    let content: String
    let lastModifiedDate: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case content = "body"
        case lastModifiedDate = "lastModified"
    }
}
