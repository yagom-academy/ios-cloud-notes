import Foundation

extension DateFormatter {
    func makeLocaleDateFormatter() -> DateFormatter {
        let locale = Locale.preferredLanguages[0]
        self.locale = Locale(identifier: locale)
        self.dateStyle = .medium
        self.timeStyle = .none
        return self
    }
}
