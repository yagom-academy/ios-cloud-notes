import Foundation

struct NoteInformation {
    let title: String
    let content: String
    let lastModifiedDate: Double
    
    var localizedDateString: String {
        return DateFormatter().localizedString(from: self.lastModifiedDate)
    }
}
