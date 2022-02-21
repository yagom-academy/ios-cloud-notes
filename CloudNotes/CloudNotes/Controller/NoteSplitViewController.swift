import UIKit
import CoreData

class NoteSplitViewController: UISplitViewController {
// MARK: - Property
    private var dataManager: CoreDataManager<CDMemo>?
    private let noteListViewController = NoteListViewController()
    private let noteDetailViewController = NoteDetailViewController()
    private var fetchedController: NSFetchedResultsController<CDMemo>?
    private var selectedIndexPath: IndexPath? {
        return noteListViewController.extractSeletedRow()
    }
    private var atrributesForNewCell: [String: Any] {
        ["title": "새로운 메모", "body": "", "lastModified": Date()] as [String : Any]
    }
// MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplitViewController()
        configureNoteListViewController()
        configureColumnStyle()
        configureDataStorage()
        configureFetchedResultsController()
        dataManager?.fetchAll()
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
    
    private func configureDataStorage() {
        dataManager = CoreDataManager<CDMemo>()
    }
    
    private func configureNoteDetailViewController() {
        noteDetailViewController.delegate = self
    }
    
    private func configureFetchedResultsController(query: String? = nil) {
        if query == nil {
            fetchedController = dataManager?.createNoteFetchedResultsController()
        } else {
        fetchedController = dataManager?.createNoteFetchedResultsController(query: query)
        }
        
        try? fetchedController?.performFetch()
        fetchedController?.delegate = self
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
        guard let deletedData = fetchedController?.object(at: indexPath) else { return }
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
        
        guard let memo = fetchedController?.object(at: indexPath) else {
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
        dataManager?.create(target: CDMemo.self, attributes: atrributesForNewCell)
    }
}
// MARK: - NoteListViewController DataSource
extension NoteSplitViewController: NoteListViewControllerDataSource {
    func noteListViewControllerNumberOfData(_ viewController: NoteListViewController) -> Int {
        fetchedController?.sections?[0].numberOfObjects ?? .zero
    }
    
    func noteListViewControllerSampleForCell(_ viewController: NoteListViewController, indexPath: IndexPath) -> CDMemo? {
        fetchedController?.object(at: indexPath)
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
        
        guard let selectedMemo = fetchedController?.object(at: selectedIndexPath ?? IndexPath(row: .zero, section: .zero)) else {
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
