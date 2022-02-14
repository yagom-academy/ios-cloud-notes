import UIKit

class SplitViewController: UISplitViewController {
    private let primaryVC = MemoListViewController(style: .insetGrouped)
    private let secondaryVC = MemoDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChildView()
        setUpDisplay()
        MemoDataManager.shared.setUpMemoList()
        present(at: .zero)
        hideKeyboard()
    }
}

// MARK: - Primary related Method
extension SplitViewController {
    func updateMemoList(at index: Int) {
        primaryVC.updateData(at: index)
    }
    
    func moveTableViewCell(at index: Int) {
        primaryVC.moveCell(at: index)
    }
    
    func deleteTableViewCell(indexPath: IndexPath) {
        primaryVC.deleteCell(indexPath: indexPath)
    }
}

// MARK: - Secondary related Method
extension SplitViewController {
    func present(at indexPath: Int) {
        secondaryVC.updateData(with: indexPath)
        show(.secondary)
    }
    
    func clearMemoTextView() {
        secondaryVC.clearTextView()
    }
}

// MARK: - 초기 ViewController 설정
extension SplitViewController {
    private func setUpChildView() {
        setViewController(primaryVC, for: .primary)
        setViewController(secondaryVC, for: .secondary)
    }
    
    private func setUpDisplay() {
        delegate = self
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        view.tintColor = .systemOrange
    }
}

// MARK: - Delegate
extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
