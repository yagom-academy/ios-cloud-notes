import Foundation

struct Sample: Decodable {
    var title: String
    var body: String
    var lastModified: Int
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy. MM. dd"
        let formattedDate = Date(timeIntervalSince1970: TimeInterval(lastModified))
        
        return dateFormatter.string(from: formattedDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
