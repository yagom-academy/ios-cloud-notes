import UIKit

final class SplitViewController: UISplitViewController {
    private let dataManager = MemoDataManager()
    private let listViewController = MemoListViewController()
    private let detailViewController = MemoDetailViewController()
    
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
        dataManager.memos[indexPath.row]
    }
    
    func selectFirstMemo() {
        if dataManager.memos.isEmpty == false {
            listViewController.setupRowSelection()
            detailViewController.showTextView(with: dataManager.memos[0])
        }
    }
    
    func addNewMemo() {
        dataManager.insertMemo(at: 0)
        listViewController.addNewCell()
        detailViewController.showEmptyTextView()
    }
    
    func deleteSelectedMemo(at indexPath: IndexPath) {
        let deletedMemo = dataManager.memos[indexPath.row]
        dataManager.deleteMemo(id: deletedMemo.id)
        listViewController.deleteCell(at: indexPath)
        
        if indexPath.row < dataManager.memos.count {
            let memo = dataManager.memos[indexPath.row]
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
        let memo = dataManager.memos[indexPath.row]
        detailViewController.showTextView(with: memo)
    }
}

// MARK: - MemoDetailViewControllerDelegate

extension SplitViewController: MemoDetailViewControllerDelegate {
    func deleteSelectedMemo() {
        guard let indexPath = listViewController.selectedCellIndex else {
            return
        }
        let deletedMemo = dataManager.memos[indexPath.row]
        dataManager.deleteMemo(id: deletedMemo.id)
        listViewController.deleteCell(at: indexPath)
        
        if indexPath.row < dataManager.memos.count {
            let memo = dataManager.memos[indexPath.row]
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
        dataManager.updateMemo(id: dataManager.memos[indexPath.row].id,
                               title: title,
                               body: body,
                               lastModified: lastModified)
        listViewController.updateCell(at: indexPath)
    }
}
