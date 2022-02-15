import UIKit

class SplitViewController: UISplitViewController {
    private let listViewController = MemoListViewController()
    private let detailViewController = MemoDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChildView()
        setUpDisplay()
        listViewController.delegate = detailViewController
        detailViewController.delegate = listViewController
    }
    
    private func setUpChildView() {
        setViewController(listViewController, for: .primary)
        setViewController(detailViewController, for: .secondary)
    }
    
    private func setUpDisplay() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
    }
    
}
