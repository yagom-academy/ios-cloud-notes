import UIKit
import CoreData

class NoteSplitViewController: UISplitViewController {
    private var dataManager: CoreDataManager<CDMemo>?
    private let noteListViewController = NoteListViewController()
    private let noteDetailViewController = NoteDetailViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNoteListViewController()
        setUpSplitViewController()
        configureColumnStyle()
        configureDataStorage()
        dataManager?.fetchAll(request: CDMemo.fetchRequest())
    }
    
    private func setUpSplitViewController() {
        setViewController(noteListViewController, for: .primary)
        setViewController(noteDetailViewController, for: .secondary)
    }
    
    private func configureNoteListViewController() {
        noteListViewController.delegate = self
        noteListViewController.dataSource = self
    }
    
    private func configureDataStorage() {
        dataManager = CoreDataManager<CDMemo>()
    }
    
    private func configureColumnStyle() {
        preferredPrimaryColumnWidthFraction = 1/3
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
    }
}

extension NoteSplitViewController: NoteListViewControllerDelegate {
    func noteListViewController(_ viewController: NoteListViewController, cellToDelete indexPath: IndexPath) {
        guard let deletedData = dataManager?.extractData(indexPath: indexPath) else { return }
        dataManager?.delete(target: deletedData)
        dataManager?.fetchAll(request: CDMemo.fetchRequest())
    }
    
    func noteListViewController(_ viewController: NoteListViewController, didSelectedCell indexPath: IndexPath) {
        guard let secondaryViewController = self.viewController(
            for: .secondary) as? NoteDetailViewController else {
            return
        }
        
        guard let memo = dataManager?.dataList[indexPath.row] else {
            return
        }
        secondaryViewController.setUpText(with: memo)
    }
    
    func createNewMemo(completion: @escaping () -> Void) {
        let attributes = [ "title": "새로운 메모", "body": "", "lastModified": Date()] as [String : Any]
        dataManager?.create(target: CDMemo.self, attributes: attributes)
        dataManager?.fetchAll(request: CDMemo.fetchRequest())
        completion()
    }
}

extension NoteSplitViewController: NoteListViewControllerDataSource {
    func noteListViewControllerNumberOfData(_ viewController: NoteListViewController) -> Int {
        dataManager?.dataList.count ?? .zero
    }
    
    func noteListViewControllerSampleForCell(_ viewController: NoteListViewController, indexPath: IndexPath) -> CDMemo? {
        dataManager?.dataList[safe: indexPath.row]
    }
}
