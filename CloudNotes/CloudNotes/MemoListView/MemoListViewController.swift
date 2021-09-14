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
    var messenger: MessengerBetweenController?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.remembersLastFocusedIndexPath = true
        configureTableView()
        configureNavigationTitle()
        configureNavigationRightBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func insertMemoList(memoList: [Memo]) {
        memoListDataSource.tableView(tableView, initializeMemoListWith: memoList)
    }

    func updateMemo(with memo: Memo?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }

        print(selectedIndexPath)
        print(memo.debugDescription)
    }

    func showDetailViewController(with data: Memo?) {
        messenger?.showDetailViewController(with: data)
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
        showDetailViewController(with: nil)
    }
}
