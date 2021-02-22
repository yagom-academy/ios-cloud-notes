import Foundation

extension Date {
    /// Returns string converted from data with user's current locale.
    func convertToString() -> String {
        let currentLocale = Locale.current.collatorIdentifier ?? "ko_KR"
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: currentLocale)
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy. MM. dd.")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
}
