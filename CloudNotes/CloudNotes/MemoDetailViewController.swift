import UIKit

class MemoDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        view.backgroundColor = .systemBackground
    }
    
    private func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: nil
        )
    }
}
