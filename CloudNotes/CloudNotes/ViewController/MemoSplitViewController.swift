import UIKit

class MemoSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let memoListTableViewController = MemoListTableViewController()
        let memoListNavigationController = UINavigationController(rootViewController: memoListTableViewController)
        
        self.viewControllers = [memoListNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
}
