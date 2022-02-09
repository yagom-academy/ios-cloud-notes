import UIKit

class NoteSplitViewController: UISplitViewController, NoteListViewControllerDelegate {
    func noteListViewController(didSelectedCell data: Sample) {
        guard let vc = viewController(for: .secondary) as? NoteDetailViewController else {
            return
        }
        vc.setUpText(with: data)
    }
    

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
    }
}
