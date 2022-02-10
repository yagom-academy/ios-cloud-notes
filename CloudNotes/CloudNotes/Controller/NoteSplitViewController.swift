import UIKit

class NoteSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSplitViewController()
    }
    
    private func setUpSplitViewController() {
        let noteListViewController = NoteListViewController()
        noteListViewController.delegate = self
        let noteDetailViewController = NoteDetailViewController()
        setViewController(noteListViewController, for: .primary)
        setViewController(noteDetailViewController, for: .secondary)
        preferredPrimaryColumnWidthFraction = 1/3
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
    }
}

extension NoteSplitViewController: NoteListViewControllerDelegate {
    func noteListViewController(didSelectedCell data: Sample) {
        guard let secondaryViewController = viewController(
            for: .secondary) as? NoteDetailViewController else {
            return
        }
        secondaryViewController.setUpText(with: data)
    }
}
