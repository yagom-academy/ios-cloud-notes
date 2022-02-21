import UIKit

extension UIViewController {
    
    func presentAlert(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        handler: ((UIAlertController) -> Void)
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        handler(alertController)
        self.present(alertController, animated: true)
    }
    
    func presentActivityView(
        items: [Any],
        activities: [UIActivity]? = nil,
        handler: ((UIActivityViewController) -> Void)
    ) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: activities)
        handler(activityViewController)
        self.present(activityViewController, animated: true)
    }
    
}

extension UIAlertController {
    
    func addAction(_ action: [UIAlertAction]) {
        action.forEach { self.addAction($0) }
    }
    
}
