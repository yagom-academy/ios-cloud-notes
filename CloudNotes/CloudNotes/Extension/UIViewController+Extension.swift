import UIKit

extension UIViewController {
  func showAlert(title: String? = nil, message: String? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    show(alertController, sender: nil)
  }
}
