import UIKit
import CoreData

class NoteSplitViewController: UISplitViewController {
// MARK: - Property
    private var dataManager: DataProvider?
    private let noteListViewController = NoteListViewController()
    private let noteDetailViewController = NoteDetailViewController()
    private var selectedIndexPath: IndexPath? {
        return noteListViewController.extractSeletedRow()
    }
    private var atrributesForNewCell: [String: Any] {
        ["title": "새로운 메모", "body": "", "lastModified": Date(), "identifier": UUID()] as [String: Any]
    }
// MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplitViewController()
        configureDataManager()
        configureNoteListViewController()
        configureColumnStyle()
        configureFetchedResultsController()
        configureNoteDetailViewController()
    }
// MARK: - Method
    private func configureSplitViewController() {
        setViewController(noteListViewController, for: .primary)
        setViewController(noteDetailViewController, for: .secondary)
    }
    
    private func configureNoteListViewController() {
        noteListViewController.delegate = self
        noteListViewController.dataSource = self
    }
    
    private func configureColumnStyle() {
        preferredPrimaryColumnWidthFraction = 1/3
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
    }
    
    private func configureDataManager() {
        dataManager = CoreDataManager<CDMemo>()
    }
    
    private func configureNoteDetailViewController() {
        noteDetailViewController.delegate = self
    }
    
    private func configureFetchedResultsController() {
        if let datamanager = dataManager as? CoreDataManager<CDMemo> {
            datamanager.fetchedController.delegate = self
        }
    }
    
    private func presentActivityView() {
        let title = "Activity View"
        let activityViewController = UIActivityViewController(
            activityItems: [title],
            applicationActivities: nil
        )
        
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(
                origin: CGPoint(x: view.frame.width/2, y: view.frame.height/2),
                size: CGSize(width: view.bounds.width/5, height: view.bounds.height/5)
            )
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func createAttributes(body: String) -> [String: Any] {
        var attribute: [String: Any] = [:]
        let title = body.components(separatedBy: "\n")[0]
        let long = body.components(separatedBy: "\n")[1...].joined()
        attribute.updateValue(title, forKey: "title")
        attribute.updateValue(long, forKey: "body")
        attribute.updateValue(Date(), forKey: "lastModified")
        return attribute
    }
}
// MARK: - NoteListViewController Delegate
extension NoteSplitViewController: NoteListViewControllerDelegate {
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToDelete indexPath: IndexPath
    ) {
        guard let deletedData = dataManager?.read(index: indexPath) else { return }
        dataManager?.delete(target: deletedData)
    }
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        didSelectedCell indexPath: IndexPath
    ) {
        guard let secondaryViewController = self.viewController(
            for: .secondary) as? NoteDetailViewController else {
                return
            }
        
        guard let memo = dataManager?.read(index: indexPath) else {
            return
        }
        secondaryViewController.setUpText(with: memo)
    }
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToShare indexPath: IndexPath
    ) {
        presentActivityView()
    }
    
    func noteListViewController(addButtonTapped viewController: NoteListViewController) {
        dataManager?.create(attributes: atrributesForNewCell)
    }
}
// MARK: - NoteListViewController DataSource
extension NoteSplitViewController: NoteListViewControllerDataSource {
    func noteListViewControllerNumberOfData(_ viewController: NoteListViewController) -> Int {
        dataManager?.countAllData() ?? .zero
    }
    
    func noteListViewControllerSampleForCell(_ viewController: NoteListViewController, indexPath: IndexPath) -> MemoType? {
        dataManager?.read(index: indexPath)
    }
}
// MARK: - NoteDetailViewController Delegate
extension NoteSplitViewController: NoteDetailViewControllerDelegate {
    func noteDetailViewController(
        didTapRightBarButton viewController: UIViewController) {
        presentActivityView()
    }
    
    func noteDetailViewController(
        _ viewController: UIViewController,
        didChangeBody body: String
    ) {
        let attribute = createAttributes(body: body)
        
        guard let selectedMemo = dataManager?.read(index: selectedIndexPath ?? IndexPath(row: .zero, section: .zero)) else {
            return
        }
        dataManager?.update(target: selectedMemo, attributes: attribute)
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension NoteSplitViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        noteListViewController.updateTableView()
    }
}
