import UIKit

final class MainSplitViewController: UISplitViewController {
    private var memos: [Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemos()
        setupMainSplitView()
    }
    
    private func loadMemos() {
        guard let data = NSDataAsset(name: "sample"),
              let decodedData = try? JSONDecoder().decode([Memo].self, from: data.data) else { return }
        memos = decodedData
    }
    
    private func setupMainSplitView() {
        configureSplitView()
        configureNavigationBar()
    }
    
    private func configureSplitView() {
        let listViewController = MemoListViewController(memos: memos)
        let memoViewController = MemoContentViewController()
        listViewController.memoViewController = memoViewController
        setViewController(listViewController, for: .primary)
        setViewController(memoViewController, for: .secondary)
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
