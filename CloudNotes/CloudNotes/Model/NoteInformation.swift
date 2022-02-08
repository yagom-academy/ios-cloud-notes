import Foundation

struct NoteInformation: Decodable {
    let title: String
    let content: String
    let lastModifiedDate: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case content = "body"
        case lastModifiedDate = "lastModified"
    }
    
    var localizedDateString: String {
        return DateFormatter().localizedString(from: self.lastModifiedDate)
    }
}

private extension DateFormatter {
    func localizedString(from date: TimeInterval) -> String {
        self.dateStyle = .medium
        self.timeStyle = .none
        self.locale = Locale.current
        
        let convertedDate = Date(timeIntervalSince1970: date)
        return self.string(from: convertedDate)
    }
}
