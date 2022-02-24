import UIKit

final class SplitViewController: UISplitViewController {
    private let dataManager: MemoDataManagable
    private let listViewController = MemoListViewController()
    private let detailViewController = MemoDetailViewController()
    
    init(style: UISplitViewController.Style, dataManager: MemoDataManagable) {
        self.dataManager = dataManager
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignChlidViewController()
        setupDisplay()
        registerGestureRecognizerForHidingKeyboard()
        listViewController.delegate = self
        detailViewController.delegate = self
    }
    
    private func assignChlidViewController() {
        setViewController(listViewController, for: .primary)
        setViewController(detailViewController, for: .secondary)
    }
    
    private func setupDisplay() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
    }
}

// MARK: - MemoListViewControllerDelegate

extension SplitViewController: MemoListViewControllerDelegate {
    var numberOfMemos: Int {
        dataManager.numberOfMemos
    }
    
    func getMemo(for indexPath: IndexPath) -> Memo {
        dataManager.getCurrentMemo(for: indexPath)
    }
    
    func selectFirstMemo() {
        if dataManager.isEmpty == false {
            listViewController.setupRowSelection()
            detailViewController.showTextView(with: dataManager.getCurrentMemo(for: IndexPath(row: 0, section: 0)))
        }
    }
    
    func addNewMemo() {
        dataManager.insertMemo(at: 0)
        listViewController.addNewCell()
        detailViewController.showEmptyTextView()
    }
    
    func deleteSelectedMemo(at indexPath: IndexPath) {
        let deletedMemo = dataManager.getCurrentMemo(for: indexPath)
        dataManager.deleteMemo(id: deletedMemo.id)
        listViewController.deleteCell(at: indexPath)
        
        if indexPath.row < dataManager.numberOfMemos {
            let memo = dataManager.getCurrentMemo(for: indexPath)
            detailViewController.showTextView(with: memo)
            listViewController.selectNextCell(at: indexPath)
        } else {
            detailViewController.showIneditableTextView()
        }
    }
    
    func showMemo() {
        guard let indexPath = listViewController.selectedCellIndex else {
            return
        }
        let memo = dataManager.getCurrentMemo(for: indexPath)
        detailViewController.showTextView(with: memo)
    }
}

// MARK: - MemoDetailViewControllerDelegate

extension SplitViewController: MemoDetailViewControllerDelegate {
    func deleteSelectedMemo() {
        guard let indexPath = listViewController.selectedCellIndex else {
            return
        }
        let deletedMemo = dataManager.getCurrentMemo(for: indexPath)
        dataManager.deleteMemo(id: deletedMemo.id)
        listViewController.deleteCell(at: indexPath)
        
        if indexPath.row < dataManager.numberOfMemos {
            let memo = dataManager.getCurrentMemo(for: indexPath)
            detailViewController.showTextView(with: memo)
            listViewController.selectNextCell(at: indexPath)
        } else {
            detailViewController.showIneditableTextView()
        }
    }
    
    func updateEditedMemo(title: String, body: String, lastModified: Date) {
        guard let indexPath = listViewController.selectedCellIndex else {
            return
        }
        dataManager.updateMemo(id: dataManager.getCurrentMemo(for: indexPath).id,
                               title: title,
                               body: body,
                               lastModified: lastModified)
        listViewController.updateCell(at: indexPath)
    }
}
