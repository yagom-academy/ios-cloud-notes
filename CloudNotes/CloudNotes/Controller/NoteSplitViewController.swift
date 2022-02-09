import UIKit

class NoteSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSplitViewController()
    }
    
    private func setUpSplitViewController() {
        let noteListViewController = NoteListViewController()
        let noteDetailViewController = NoteDetailViewController()
        setViewController(noteListViewController, for: .primary)
        setViewController(noteDetailViewController, for: .secondary)
        preferredPrimaryColumnWidthFraction = 1/3
        preferredDisplayMode = .oneBesideSecondary
    }
}
