import UIKit
import CoreData

class NoteSplitViewController: UISplitViewController {
    private var dataStorage: CoreDataManager<CDMemo>?
    private let noteListViewController = NoteListViewController()
    private let noteDetailViewController = NoteDetailViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNoteListViewController()
        setUpSplitViewController()
        configureColumnStyle()
        configureDataStorage()
        dataStorage?.fetchAll(request: CDMemo.fetchRequest())
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
        dataStorage = CoreDataManager<CDMemo>()
    }
    
    private func configureColumnStyle() {
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
        
        guard let memo = dataStorage?.dataList[indexPath.row] else {
            return
        }
        secondaryViewController.setUpText(with: memo)
    }
    
    func createNewMemo(completion: @escaping () -> Void) {
        let attributes = [ "title": "새로운 메모", "body": "", "lastModified": Date()] as [String : Any]
        dataStorage?.create(target: CDMemo.self, attributes: attributes)
        dataStorage?.fetchAll(request: CDMemo.fetchRequest())
        completion()
    }
}

extension NoteSplitViewController: NoteListViewControllerDataSource {
    func noteListViewControllerNumberOfData(_ viewController: NoteListViewController) -> Int {
        dataStorage?.dataList.count ?? .zero
    }
    
    func noteListViewControllerSampleForCell(_ viewController: NoteListViewController, indexPath: IndexPath) -> CDMemo? {
        dataStorage?.dataList[safe: indexPath.row]
    }
}
