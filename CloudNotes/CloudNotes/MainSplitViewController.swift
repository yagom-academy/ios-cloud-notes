import UIKit

class MainSplitViewController: UISplitViewController {
    override init(style: UISplitViewController.Style = .doubleColumn) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
