import UIKit

class MemoSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
        configureSplitViewController()
    }
    
    private func configureViewControllers() {
        let memoListTableViewController = MemoListTableViewController()
        let memoContentsViewController = MemoContentsViewController()
        let memoListNavigationController = UINavigationController(rootViewController: memoListTableViewController)
        let memoContentsNavigationViewController = UINavigationController(rootViewController: memoContentsViewController)
//        memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[0])
        
        self.viewControllers = [memoListNavigationController, memoContentsNavigationViewController]
    }
    
    private func configureSplitViewController() {
        self.delegate = self
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
