import Foundation

extension DateFormatter {
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .current
        dateFormatter.dateFormat = NSLocalizedString("dd. MM. yyyy.", comment: "")
        
        return dateFormatter
    }()
}
