import UIKit

class MemoSplitViewController: UISplitViewController {
    private let memoListTableViewController = MemoListTableViewController()
    private let memoContentsViewController = MemoContentsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        let memoListNavigationController = UINavigationController(rootViewController: memoListTableViewController)
        let memoContentsNavigationViewController = UINavigationController(rootViewController: memoContentsViewController)
//        memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[0])

        self.viewControllers = [memoListNavigationController, memoContentsNavigationViewController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
}

extension MemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        let isCellSeleted = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isCellSelected.rawValue)
        return !isCellSeleted
    }
}
