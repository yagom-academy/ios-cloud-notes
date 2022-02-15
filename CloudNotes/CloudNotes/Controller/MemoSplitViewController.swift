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
    private var memos = [Memo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureSplitViewController()
        fetchAll()
    }
    
    private func configureSplitViewController() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        setViewController(memoTableViewController, for: .primary)
        setViewController(memoDetailViewController, for: .secondary)
    }
    
    func deleteMemo(at indexPath: IndexPath) {
        presentDeleteAlert(at: indexPath)
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
        memoDetailViewController.updateMemo(text: memoToShow.body) // TODO: Title 추가, body 구분 
        memoDetailViewController.updateCurrentIndexPath(with: indexPath)
        show(.secondary)
    }
    
    func presentDeleteAlert(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.memoTableViewController.deleteMemo(at: indexPath)
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

    func delete(at indexPath: IndexPath) {
        let memoToDelete = memos[indexPath.row]
        memoStorage.delete(memo: memoToDelete)
        fetchAll()
    }
}
