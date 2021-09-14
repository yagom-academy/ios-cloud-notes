//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class MemoListViewController: UITableViewController {
    private let memoListDataSource = MemoListViewDataSource()
    private var memoListDelegator: MemoListViewDelegate?
    private var lastIndexPath: IndexPath?

    var messenger: MessengerBetweenController?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationTitle()
        configureNavigationRightBarButtonItem()
    }

    func insertMemoList(memoList: [Memo]) {
        memoListDataSource.tableView(tableView, initializeMemoListWith: memoList)
    }

    func updateMemo(with memo: Memo?) {
        guard let selectedIndexPath = lastIndexPath else {
            return
        }

        memoListDataSource.tableView(tableView, updateRowAt: selectedIndexPath, with: memo)
        lastIndexPath = nil
    }

    func showDetailViewController(at indexPath: IndexPath) {
        messenger?.showDetailViewController(with: memoListDataSource[indexPath])
        lastIndexPath = indexPath
    }

}

// MARK: - Draw View
extension MemoListViewController {
    private func configureTableView() {
        let basicInset = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: .zero,
            right: .zero
        )
        let horizontalMargin: CGFloat = 10

        memoListDelegator = MemoListViewDelegate(owner: self)
        tableView.dataSource = memoListDataSource
        tableView.delegate = memoListDelegator
        tableView.register(
            MemoListViewCell.classForCoder(),
            forCellReuseIdentifier: MemoListViewCell.identifier
        )

        tableView.separatorColor = .darkGray
        tableView.separatorInset = basicInset
        tableView.contentInset = UIEdgeInsets(
            top: .zero,
            left: horizontalMargin,
            bottom: .zero,
            right: -horizontalMargin
        )
    }

    private func configureNavigationTitle() {
        let currentPageTitle = "메모"

        navigationItem.title = currentPageTitle
    }

    private func configureNavigationRightBarButtonItem() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(showDetailViewControllerWithBlankPage)
        )

        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func showDetailViewControllerWithBlankPage() {
        messenger?.showDetailViewController(with: nil)
    }
}
