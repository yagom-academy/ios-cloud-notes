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
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        setViewController(memoListViewController, for: .primary)
        setViewController(detailMemoViewController, for: .secondary)
        memoListViewController.splitViewDelegate = self
        detailMemoViewController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        if isFisrtCellSelection == false {
            isFisrtCellSelection = true
            return .primary
        } else {
            return .secondary
        }
    }
}

extension SplitViewController: SplitViewDelegate {
  
    func selectCell(data: Memo, index: IndexPath) {
        detailMemoViewController.index = index
        detailMemoViewController.memo = data
        showDetailViewController(detailMemoViewController, sender: nil)
    }
    
    func addMemo(data: Memo) {
        detailMemoViewController.memo = data
        showDetailViewController(detailMemoViewController, sender: nil)
    }
}

extension SplitViewController: Memorizable {
    func saveMemo(with newMemo: Memo, index: IndexPath) {
        memoListViewController.memoList[index.row] = newMemo
        memoListViewController.tableView.reloadData()
    }
}

