import UIKit

final class SplitViewController: UISplitViewController {
    private let dataManager = MemoDataManager()
    private lazy var listViewController = MemoListViewController(dataManager: dataManager)
    private lazy var detailViewController = MemoDetailViewController(dataManager: dataManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignChlidViewController()
        setupDisplay()
        registerGestureRecognizerForHidingKeyboard()
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


// MARK: - MemoDataManagerListDelegate

extension SplitViewController {
    func selectFirstMemo() {
        if dataManager.memos.isEmpty == false {
            listViewController.setupRowSelection()
            detailViewController.showTextView(with: dataManager.memos[0])
        }
    }
    
    func addNewMemo() {
        dataManager.memos.insert(dataManager.newMemo, at: 0)
        listViewController.addNewCell()
        detailViewController.showEmptyTextView()
    }
    
    func deleteSelectedMemo(at indexPath: IndexPath? = nil) {
        let selectedIndexPath: IndexPath?
        if indexPath != nil {
            selectedIndexPath = indexPath
        } else {
            selectedIndexPath = listViewController.selectedCellIndex
        }
        
        guard let selectedIndexPath = selectedIndexPath else {
            return
        }
        let deletedMemo = dataManager.memos[selectedIndexPath.row]
        dataManager.deleteMemo(id: deletedMemo.id)
        listViewController.deleteCell(at: selectedIndexPath)
        
        if selectedIndexPath.row < dataManager.memos.count {
            let memo = dataManager.memos[selectedIndexPath.row]
            detailViewController.showTextView(with: memo)
            listViewController.selectNextCell(at: selectedIndexPath)
        } else {
            detailViewController.showIneditableTextView()
        }
    }
    
    func updateEditedMemo(title: String, body: String, lastModified: Date) {
        guard let indexPath = listViewController.selectedCellIndex else {
            return
        }
        dataManager.updateMemo(id: dataManager.memos[indexPath.row].id, title: title, body: body, lastModified: lastModified)
        listViewController.updateCell(at: indexPath)
    }
    
    func showMemo() {
        guard let indexPath = listViewController.selectedCellIndex else {
            return
        }
        let memo = dataManager.memos[indexPath.row]
        detailViewController.showTextView(with: memo)
    }
}
