import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        DropboxManager().upload { result in
            switch result {
            case .success:
                print("Upload Success".localized())
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showActivityViewController(data: String...) {
        let activityViewController = UIActivityViewController(
            activityItems: data,
            applicationActivities: nil
        )
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = splitViewController?.view
            popoverController.sourceRect = CGRect(
                x: splitViewController?.view.bounds.midX ?? .zero,
                y: splitViewController?.view.bounds.midY ?? .zero,
                width: .zero,
                height: .zero
            )
            popoverController.permittedArrowDirections = []
            let splitViewController = self.splitViewController as? SplitViewController
            splitViewController?.popoverController = popoverController
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showNoteActionSheet(
        shareHandler: @escaping (UIAlertAction) -> Void,
        deleteHandler: @escaping (UIAlertAction) -> Void,
        barButtonItem: UIBarButtonItem? = nil
    ) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share...".localized(), style: .default, handler: shareHandler)
        shareAction.setValue(0, forKey: "titleTextAlignment")
        shareAction.setValue(UIImage(systemName: "square.and.arrow.up"), forKey: "image")
        
        let deleteAction = UIAlertAction(title: "Delete".localized(), style: .destructive, handler: deleteHandler)
        deleteAction.setValue(0, forKey: "titleTextAlignment")
        deleteAction.setValue(UIImage(systemName: "trash.fill"), forKey: "image")
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.splitViewController?.view
            popoverController.barButtonItem = barButtonItem
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Notice".localized(), message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .default, handler: nil)
        let okAction = UIAlertAction(title: actionTitle, style: .destructive, handler: handler)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Notice".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default, handler: handler)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
