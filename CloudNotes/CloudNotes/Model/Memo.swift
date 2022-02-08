import Foundation

struct Memo: Codable {
    let title, body: String
    let lastModified: TimeInterval
    
    var convertedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yyyy. MM. dd."
        let currentDate = Date(timeIntervalSince1970: lastModified)
        return dateFormatter.string(from: currentDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
