import UIKit

final class MainSplitViewController: UISplitViewController {
    private var memos: [Memo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMemo()
        configure()
    }
    
    private func loadMemo() {
        guard let data = NSDataAsset(name: "sample"),
              let memos = try? JSONDecoder().decode([Memo].self, from: data.data) else {
                  return
              }
        self.memos = memos
    }
    
    private func configure() {
        configureSplitView()
        configureNavigationBar()
    }
    
    private func configureSplitView() {
        let listViewController = ListViewController(memos: memos)
        let memoViewController = MemoViewController()
        listViewController.memoDelegate = memoViewController
        setViewController(listViewController, for: .primary)
        setViewController(memoViewController, for: .secondary)
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
