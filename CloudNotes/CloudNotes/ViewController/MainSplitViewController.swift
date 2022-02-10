import UIKit

final class MainSplitViewController: UISplitViewController {
    private let listViewController = MemoListViewController()
    private let contentViewController = MemoContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainSplitView()
    }
    
    func updateMemoContentsView(with memo: Memo) {
        contentViewController.updateTextView(with: memo)
        showDetailViewController(contentViewController, sender: nil)
    }
     
    private func setupMainSplitView() {
        configureSplitView()
        configureNavigationBar()
    }
    
    private func configureSplitView() {
        setViewController(listViewController, for: .primary)
        setViewController(contentViewController, for: .secondary)
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
