import UIKit

class MainSplitViewController: UISplitViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController(ListViewController(), for: .primary)
        setViewController(ListViewController(), for: .secondary)
        self.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
