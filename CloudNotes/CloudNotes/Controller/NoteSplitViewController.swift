import UIKit

class NoteSplitViewController: UISplitViewController {
    let noteListViewController = NoteListViewController()
    let noteDetailViewController = NoteDetailViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        noteListViewController.delegate = self
        setUpSplitViewController()
    }
    
    private func setUpSplitViewController() {
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
