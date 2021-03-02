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
        
        if !(CoreDataSingleton.shared.memoData.isEmpty) {
            memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[0])
        } else {
            self.viewControllers = [memoListNavigationController]
            self.view.backgroundColor = .white
            return
        }
        
        self.viewControllers = [memoListNavigationController, memoContentsNavigationViewController]
        memoContentsViewController.delegate = memoListTableViewController
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
