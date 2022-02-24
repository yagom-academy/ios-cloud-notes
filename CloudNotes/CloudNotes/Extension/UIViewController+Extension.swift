import UIKit

extension UIViewController {
  func showAlert(title: String? = nil, message: String? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "confirm", style: .default)
    alertController.addAction(confirmAction)
    present(alertController, animated: true)
  }
}
