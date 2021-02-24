import UIKit

class MemoSplitViewController: UISplitViewController {
    private let memoListTableViewController = MemoListTableViewController(style: .plain)
    private let memoContentsViewController = MemoContentsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        let memoListNavigationController = UINavigationController(rootViewController: memoListTableViewController)
        memoContentsViewController.receiveText(memo: memoListTableViewController.memoList[0])

        self.viewControllers = [memoListNavigationController, memoContentsViewController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
}

extension MemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return !memoListTableViewController.isCellSelected
    }
}
