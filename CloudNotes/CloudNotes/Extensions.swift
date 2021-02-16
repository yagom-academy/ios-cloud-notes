import Foundation

extension DateFormatter {
    func makeLocaleDateFormatter() -> DateFormatter {
        let locale = Locale.preferredLanguages[0]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
}
