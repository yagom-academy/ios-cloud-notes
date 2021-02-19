import Foundation

extension DateFormatter {
    func makeLocaleDateFormatter() -> DateFormatter {
        if let identifier = Locale.current.collatorIdentifier {
            self.locale = Locale(identifier: identifier)
        } else {
            self.locale = Locale(identifier: Locale.current.identifier)
        }
        self.dateStyle = .medium
        self.timeStyle = .none
        return self
    }
}
