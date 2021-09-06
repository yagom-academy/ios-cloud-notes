//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/01.
//

import UIKit

class SplitViewController: UISplitViewController {

    var isFisrtCellSelection = false
    private let memoListViewController = MemoListViewController()
    private let detailMemoViewController = DetailMemoViewController()
    
    init() {
        super.init(style: .doubleColumn)
        configureSplitView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureSplitView() {
        self.delegate = self
        memoListViewController.delegate = self
        detailMemoViewController.delegate = self
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        setViewController(memoListViewController, for: .primary)
        setViewController(detailMemoViewController, for: .secondary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        if isFisrtCellSelection == false {
            return .primary
        } else {
            isFisrtCellSelection = true
            return .secondary
        }
    }
}

extension SplitViewController: MemoListDelegate {
  
    func selectCell(data: Memo, index: IndexPath) {
        detailMemoViewController.index = index
        detailMemoViewController.memo = data
        showDetailViewController(detailMemoViewController, sender: nil)
    }
    
    func addMemo(data: Memo, index: IndexPath) {
        detailMemoViewController.index = index
        detailMemoViewController.memo = data
        showDetailViewController(detailMemoViewController, sender: nil)
    }
}

extension SplitViewController: DetailMemoDelegate {
    
    func saveMemo(with newMemo: Memo, index: IndexPath) {
        memoListViewController.memoList[index.row].title = newMemo.title
        memoListViewController.memoList[index.row].body = newMemo.body
        memoListViewController.memoList[index.row].date = newMemo.date
        memoListViewController.tableView.reloadData()
    }
}
