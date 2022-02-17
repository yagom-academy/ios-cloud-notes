import Foundation

struct Content: Decodable {
    var title: String
    var body: String
    var lastModifiedDate: Double
    var identification: UUID

    enum CodingKeys: String, CodingKey {
        case title, body, identification
        case lastModifiedDate = "last_modified"
    }
}

extension Content {
    var formattedDateString: String {
        let date = Date(timeIntervalSince1970: self.lastModifiedDate)
        return DateFormatter.memoDate.string(from: date)
    }
}
