import UIKit

class MemoSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memoListTableVC = MemoListTableViewController()
        let memoContentsVC = MemoContentsViewController()
        let a = UINavigationController(rootViewController: memoListTableVC)
        let b = UINavigationController(rootViewController: memoContentsVC)
        b.navigationBar.isHidden = true
    
        self.viewControllers = [a, b]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
        
    }
}
