//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import UIKit

class MemoSplitViewController: UISplitViewController {
    private lazy var memoTableViewController = MemoTableViewController(style: .insetGrouped, delegate: self)
    private lazy var memoDetailViewController = MemoDetailViewController(delegate: self)
    private let memoStorage = MemoStorage()
    private var memos = [Memo]() {
        didSet {
            memos.sort { $0.lastModified > $1.lastModified }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureSplitViewController()
        fetchAll()
    }
    
    func deleteMemo(at indexPath: IndexPath) {
        presentDeleteAlert(at: indexPath)
    }
    
    private func configureSplitViewController() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        setViewController(memoTableViewController, for: .primary)
        setViewController(memoDetailViewController, for: .secondary)
    }
    
    private func presentDeleteCautionAlert() {
        let alert = UIAlertController(title: "삭제할 수 없습니다", message: "메모는 최소 한 개 존재해야합니다", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UISplitViewControllerDelegate

extension MemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

// MARK: - MemoManageable

extension MemoSplitViewController: MemoSplitViewManageable {
    func showPrimaryView() {
        show(.primary)
    }
    
    func showSecondaryView(of indexPath: IndexPath) {
        let memoToShow = memos[indexPath.row]
        memoDetailViewController.updateMemo(title: memoToShow.title, body: memoToShow.body) 
        memoDetailViewController.updateCurrentIndexPath(with: indexPath)
        show(.secondary)
    }
    
    func presentDeleteAlert(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.delete(at: indexPath)
            if self.isCollapsed {
                self.showPrimaryView()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true)
    }
    
    func presentShareActivity(at indexPath: IndexPath) {
        let memoToShare = memos[indexPath.row]
        let shareActivity = UIActivityViewController(activityItems: [memoToShare.title, memoToShare.body], applicationActivities: nil)

        shareActivity.modalPresentationStyle = .popover
        shareActivity.popoverPresentationController?.sourceRect = CGRect(origin: self.view.center, size: .zero)
        shareActivity.popoverPresentationController?.sourceView = self.view
        shareActivity.popoverPresentationController?.permittedArrowDirections = []

        self.present(shareActivity, animated: true, completion: nil)
    }
    
    func reloadRow(at indexPath: IndexPath, title: String, body: String) {
        let memo = memos[indexPath.row]
        memo.title = title
        memo.body = body
        self.memoTableViewController.tableView.reloadRows(at: [indexPath], with: .none)
        self.memoTableViewController.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
}

// MARK: - MemoStorageManageable

extension MemoSplitViewController: MemoStorageManageable {
    var isMemoStorageEmpty: Bool {
        return memos.isEmpty
    }
    
    var memosCount: Int {
        return memos.count
    }
    
    func create() {
        memoStorage.create()
        fetchAll()
    }
    
    func fetchAll() {
        memos = memoStorage.fetchAll()
    }
    
    func fetch(at indexPath: IndexPath) -> Memo {
        return memos[indexPath.row]
    }
    
    func update(at indexPath: IndexPath, title: String, body: String) {
        let memoToUpdate = memos[indexPath.row]
        memoStorage.update(to: memoToUpdate, title: title, body: body)
        fetchAll()
        self.memoTableViewController.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
    }

    func delete(at indexPath: IndexPath) {
        guard memos.count > 1 else {
            presentDeleteCautionAlert()
            return
        }
        
        let memoToDelete = memos[indexPath.row]
        memoStorage.delete(memo: memoToDelete)
        fetchAll()
        
        self.memoTableViewController.deleteRow(at: indexPath)
        let selectedIndexPath = self.memoTableViewController.selectedIndexPath
        var newIndexPath = selectedIndexPath
        
        if selectedIndexPath.row > indexPath.row {
            newIndexPath = IndexPath(row: selectedIndexPath.row - 1, section: selectedIndexPath.section)
        } else if selectedIndexPath.row == memos.count {
            newIndexPath = IndexPath(row: selectedIndexPath.row - 1, section: selectedIndexPath.section)
        }
        
        self.memoTableViewController.updateSelectedIndexPath(with: newIndexPath)
        showSecondaryView(of: newIndexPath)
    }
}
