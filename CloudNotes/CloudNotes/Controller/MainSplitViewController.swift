import UIKit

class MainSplitViewController: UISplitViewController {
    private var masterViewController: MasterTableViewController!
    private var detailViewController: DetailViewController!
    
    override init(style: UISplitViewController.Style = .doubleColumn) {
        super.init(style: style)
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
        
        detailViewController = DetailViewController()
        masterViewController = MasterTableViewController(style: .plain, delegate: detailViewController)
        
        self.viewControllers = [
            UINavigationController(rootViewController: masterViewController),
            UINavigationController(rootViewController: detailViewController)
        ]
    }
}
