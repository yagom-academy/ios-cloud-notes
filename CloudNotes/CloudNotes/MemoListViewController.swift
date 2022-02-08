import UIKit

class MemoListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
}
