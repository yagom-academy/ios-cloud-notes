import UIKit

class SplitViewController: UISplitViewController {
    private let primaryVC = NotesViewController(style: .insetGrouped)
    private let secondaryVC = NoteDetailViewController()
    var popoverController: UIPopoverPresentationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChildView()
        setUpDisplay()
        PersistentManager.shared.setUpNotes()
        present(at: .zero)
        hideKeyboard()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let popoverController = self.popoverController {
            popoverController.sourceRect = CGRect(
                x: size.width * 0.5,
                y: size.height * 0.5,
                width: .zero,
                height: .zero
            )
        }
    }
}

// MARK: - Primary Related Method
extension SplitViewController {
    func updateNotes(at index: Int) {
        primaryVC.updateData(at: index)
    }
    
    func moveTableViewCell(at index: Int) {
        primaryVC.moveCell(at: index)
    }
    
    func deleteTableViewCell(indexPath: IndexPath) {
        primaryVC.deleteCell(indexPath: indexPath)
    }
}

// MARK: - Secondary Related Method
extension SplitViewController {
    func present(at indexPath: Int) {
        secondaryVC.updateData(with: indexPath)
        show(.secondary)
    }
    
    func clearNoteTextView() {
        secondaryVC.clearTextView()
    }
}

// MARK: - SetUp Initial ViewController
extension SplitViewController {
    private func setUpChildView() {
        setViewController(primaryVC, for: .primary)
        setViewController(secondaryVC, for: .secondary)
    }
    
    private func setUpDisplay() {
        delegate = self
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        view.tintColor = .systemOrange
    }
}

// MARK: - Delegate
extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
