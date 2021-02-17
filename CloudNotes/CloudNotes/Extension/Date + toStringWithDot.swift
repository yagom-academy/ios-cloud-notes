import Foundation

extension Date {
    func toStringWithDot() -> String {
        let currentLocale = Locale.current.regionCode ?? "ko_KR"
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: currentLocale)
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy. MM. dd.")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
}
