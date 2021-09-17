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

    var messenger: MessengerForListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationTitle()
        configureNavigationRightBarButtonItem()
    }

    func showDetailViewController(at indexPath: IndexPath) {
        messenger?.showDetailViewController(with: memoListDataSource[indexPath])
        lastIndexPath = indexPath
    }

    func assignLastIndexPath(with indexPath: IndexPath) {
        lastIndexPath = indexPath
    }
}

// MARK: - Managing DataSource with MessengerForListViewController
extension MemoListViewController {
    func showActionSheet() {
        messenger?.showActionSheet()
    }

    func insertMemoList(memoList: [Memo]) {
        memoListDataSource.tableView(tableView, initializeMemoListWith: memoList)
    }

    func configure(with memo: Memo?) {
        guard let memo = memo else {
            return
        }

        if let selectedIndexPath = lastIndexPath {
            updateMemo(with: memo, at: selectedIndexPath)
        } else {
            insertMemo(with: memo)
        }
    }

    func deleteMemo() {
        guard let indexPath = lastIndexPath else {
            return
        }

        messenger?.deleteMemo(at: indexPath.row)
        memoListDataSource.tableView(tableView, deleteRowAt: indexPath)
    }

    private func insertMemo(with memo: Memo) {
        messenger?.createMemo(with: memo)
        memoListDataSource.tableView(tableView, insertRowWith: memo)
    }

    private func updateMemo(with memo: Memo, at indexPath: IndexPath) {
        messenger?.updateMemo(memo, at: indexPath.row)
        memoListDataSource.tableView(tableView, updateRowAt: indexPath, with: memo)
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

        addButton.accessibilityLabel = "신규 메모 추가"
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func showDetailViewControllerWithBlankPage() {
        messenger?.showDetailViewController(with: nil)
        lastIndexPath = nil
    }
}
