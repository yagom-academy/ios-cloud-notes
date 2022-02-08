import Foundation

struct Note: Decodable {
    var title: String
    var body: String
    var lastModifiedDate: Double

    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModifiedDate = "last_modified"
    }
}

extension Note {
    var formattedDateString: String {
        let date = Date(timeIntervalSince1970: self.lastModifiedDate)
        return DateFormatter.memoDate.string(from: date)
    }
}
