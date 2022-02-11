import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showActivityViewController(view: UIViewController, data: String...) {
        let activityViewController = UIActivityViewController(
            activityItems: data,
            applicationActivities: nil
        )
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = view.view
            popoverController.sourceRect = CGRect(
                x: view.view.bounds.midX,
                y: view.view.bounds.midY,
                width: 0,
                height: 0
            )
            popoverController.permittedArrowDirections = []
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showMemoActionSheet(shareHandler: @escaping (UIAlertAction) -> Void, deleteHandler: @escaping (UIAlertAction) -> Void, sender: UIBarButtonItem? = nil) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default, handler: shareHandler)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.splitViewController?.view
            popoverController.barButtonItem = sender as? UIBarButtonItem

        }
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, actionTitle: String, handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: actionTitle, style: .destructive, handler: handler)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
