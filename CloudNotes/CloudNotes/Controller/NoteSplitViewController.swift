import UIKit

class NoteSplitViewController: UISplitViewController {
    let dataStorage = DataStorage()
    let noteListViewController = NoteListViewController()
    let noteDetailViewController = NoteDetailViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        noteListViewController.delegate = self
        noteListViewController.dataSource = self
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
    func noteListViewController(_ viewController: NoteListViewController, didSelectedCell indexPath: IndexPath) {
        guard let secondaryViewController = self.viewController(
            for: .secondary) as? NoteDetailViewController else {
            return
        }
        secondaryViewController.setUpText(with: dataStorage.assetData[indexPath.row])
    }
}

extension NoteSplitViewController: NoteListViewControllerDataSource {
    func noteListViewControllerNumberOfData(_ viewController: NoteListViewController) -> Int {
        dataStorage.assetData.count ?? .zero
    }
    
    func noteListViewControllerSampleForCell(_ viewController: NoteListViewController, indexPath: IndexPath) -> Sample? {
        dataStorage.assetData[safe: indexPath.row]
    }
    
    
}
