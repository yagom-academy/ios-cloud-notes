import UIKit

final class SplitViewController: UISplitViewController {
    private let dataManager = MemoDataManager()
    private lazy var listViewController = MemoListViewController(dataManager: dataManager)
    private lazy var detailViewController = MemoDetailViewController(dataManager: dataManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignChlidViewController()
        setupDisplay()
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
