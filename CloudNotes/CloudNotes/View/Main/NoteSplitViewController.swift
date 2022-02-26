import UIKit
import CoreData

class NoteSplitViewController: UISplitViewController {
// MARK: - Property
    private var dataManager: DataManager?
    private let modeChanger = MemoModeChanger()
    private let noteListViewController = NoteListViewController()
    private let noteDetailViewController = NoteDetailViewController()
    private var selectedIndexPath: IndexPath? {
        return noteListViewController.extractSeletedRow()
    }
// MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSplitViewController()
        self.configureIntialDataManager()
        self.configureNoteListViewController()
        self.configureColumnStyle()
        self.configureFetchedResultsController()
        self.configureNoteDetailViewController()
    }
// MARK: - Method
    private func configureSplitViewController() {
        setViewController(noteListViewController, for: .primary)
        setViewController(noteDetailViewController, for: .secondary)
    }
    
    private func configureNoteListViewController() {
        self.noteListViewController.delegate = self
        self.noteListViewController.dataSource = self
    }
    
    private func configureColumnStyle() {
        preferredPrimaryColumnWidthFraction = 1/2
        preferredDisplayMode = .twoBesideSecondary
        preferredSplitBehavior = .tile
    }
    
    private func configureIntialDataManager() {
        self.dataManager = modeChanger.factoryDataManager(mode: ModeChecker.currentMode)
        self.noteListViewController.updateTableView()
    }
    
    private func switchDataManager() {
        self.dataManager = modeChanger.factoryDataManager(mode: ModeChecker.currentMode)
        self.noteListViewController.updateTableView()
    }
    
    private func configureNoteDetailViewController() {
        self.noteDetailViewController.delegate = self
    }
    
    private func configureFetchedResultsController() {
        if let datamanager = self.dataManager as? CoreDataManager<CDMemo> {
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
    
    private func presentModeChangeAlert(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let asset = UIAlertAction(title: "Asset", style: .default) { [weak self] _ in
            self?.modeChanger.switchMode(to: .asset)
            self?.switchDataManager()
        }
        let coreData = UIAlertAction(title: "CoreData", style: .default) { [weak self] _ in
            self?.modeChanger.switchMode(to: .coreData)
            self?.switchDataManager()
        }
        let dropBox = UIAlertAction(title: "Dropbox", style: .default) { [weak self] _ in
            self?.modeChanger.switchMode(to: .dropBox)
            self?.switchDataManager()
        }
        actionSheet.addAction(asset)
        actionSheet.addAction(coreData)
        actionSheet.addAction(dropBox)
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender as? UIBarButtonItem
        }

        self.present(actionSheet, animated: false)
    }
}
// MARK: - NoteListViewController Delegate
extension NoteSplitViewController: NoteListViewControllerDelegate {
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToDelete indexPath: IndexPath
    ) {
        guard let deletedData = dataManager?.read(index: indexPath) else {
            return
        }
        dataManager?.delete(target: deletedData)
    }
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        didSelectedCell indexPath: IndexPath
    ) {
        guard let secondaryViewController = self.viewController(for: .secondary) as? NoteDetailViewController
        else {
            return
        }
        
        guard let memo = dataManager?.read(index: indexPath)
        else {
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
    
    func noteListViewController(
        _ viewController: NoteListViewController,
        cellToUpload indexPath: IndexPath
    ) {
        guard let memoToUpdate = self.dataManager?.read(index: indexPath) as? MemoType
        else {
            return
        }
        
        DropBoxManager().update(target: memoToUpdate, attributes: [:] )
    }
    
    func noteListViewController(addButtonTapped viewController: NoteListViewController) {
        self.dataManager?.create(attributes: MemoFormat.defaults.attributes)
    }
}
// MARK: - NoteListViewController DataSource
extension NoteSplitViewController: NoteListViewControllerDataSource {
    func noteListViewControllerNumberOfData(_ viewController: NoteListViewController) -> Int {
        self.dataManager?.countAllData() ?? .zero
    }
    
    func noteListViewControllerSampleForCell(_ viewController: NoteListViewController, indexPath: IndexPath) -> MemoType? {
        self.dataManager?.read(index: indexPath)
    }
}
// MARK: - NoteDetailViewController Delegate
extension NoteSplitViewController: NoteDetailViewControllerDelegate {
    func noteDetailViewController(
        didTapRightBarButton viewController: UIViewController, sender: AnyObject) {
            self.presentModeChangeAlert(sender: sender)
    }
    
    func noteDetailViewController(
        _ viewController: UIViewController,
        didChangeBody body: String
    ) {
        guard let selectedMemo = dataManager?.read(index: selectedIndexPath ?? IndexPath(row: .zero, section: .zero))
        else {
            return
        }
        let attribute = selectedMemo.createAttributes(body: body)
        
        self.dataManager?.update(target: selectedMemo, attributes: attribute)
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension NoteSplitViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.noteListViewController.updateTableView()
    }
}
