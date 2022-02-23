import UIKit

final class MainSplitViewController: UISplitViewController {
    override init(style: UISplitViewController.Style = .doubleColumn) {
        super.init(style: style)
    }
    
    convenience init(masterViewController: MasterTableViewController, detailViewController: DetailViewController, style: UISplitViewController.Style = .doubleColumn) {
        self.init(style: style)
        configureChildViewController(masterViewController, detailViewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
    }
    
    private func configureChildViewController(_ masterViewController: MasterTableViewController, _ detailViewController: DetailViewController) {
        viewControllers = [masterViewController, detailViewController]
    }
}
