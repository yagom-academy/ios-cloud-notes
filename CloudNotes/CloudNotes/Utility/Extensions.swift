import UIKit

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

extension UIViewController {
    func showErrorAlert(viewController: UIViewController, message: String) {
        let alertController = UIAlertController(title: "에러!", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
