import UIKit

class MemoSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memoListTableViewController = MemoListTableViewController()
        let memoContentsViewController = MemoContentsViewController()
        let memoListNavigationController = UINavigationController(rootViewController: memoListTableViewController)
        let memoContentsNavigationController = UINavigationController(rootViewController: memoContentsViewController)
        memoContentsNavigationController.navigationBar.isHidden = true
    
        self.viewControllers = [memoListNavigationController, memoContentsNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
}
