import UIKit
// MARK: - Declare NoteDetailViewControllerDelegate
protocol NoteDetailViewControllerDelegate: AnyObject {
    
    func noteDetailViewController(_ viewController: UIViewController, didChangeBody body: String)
    
    func noteDetailViewController(didTapRightBarButton viewController: UIViewController, sender: AnyObject)
}
