import UIKit

class SplitViewController: UISplitViewController {
    private let listViewController = MemoListViewController()
    private let detailViewController = MemoDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildView()
        setupDisplay()
        listViewController.delegate = detailViewController
        detailViewController.delegate = listViewController
        hideKeyboard()
    }
    
    private func setupChildView() {
        setViewController(listViewController, for: .primary)
        setViewController(detailViewController, for: .secondary)
    }
    
    private func setupDisplay() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
    }
}
