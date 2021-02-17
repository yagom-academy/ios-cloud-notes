import Foundation

extension Date {
    func toStringWithDot() -> String {
//        guard let currentLocale = Locale.current.regionCode else {
//            return "en_US"
//        }
        
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: currentLocale)
//        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy. MM. dd.")
        
        dateFormatter.dateFormat = "yyyy. MM. dd."
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
