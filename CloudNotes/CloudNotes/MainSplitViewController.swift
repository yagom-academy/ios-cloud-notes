import UIKit

class MainSplitViewController: UISplitViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController(ListViewController(), for: .primary)
        setViewController(MemoViewController(), for: .secondary)
        self.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
