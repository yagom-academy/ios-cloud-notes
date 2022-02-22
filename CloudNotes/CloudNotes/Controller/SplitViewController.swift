import UIKit

final class SplitViewController: UISplitViewController {
    private let listViewController = MemoListViewController()
    private let detailViewController = MemoDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MemoDataManager.shared.loadPersistentContainer()
        MemoDataManager.shared.setMemosArray()
        assignChlidViewController()
        setupDisplay()
        listViewController.delegate = detailViewController
        detailViewController.delegate = listViewController
        registerGestureRecognizer()
    }
    
    private func assignChlidViewController() {
        setViewController(listViewController, for: .primary)
        setViewController(detailViewController, for: .secondary)
    }
    
    private func setupDisplay() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
    }
}
