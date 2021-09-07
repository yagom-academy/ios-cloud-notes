//
//  MemoListView.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class MemoListView: UITableViewController {

    private let memoListDataSource = MemoListViewDataSource()
    private var memoListDelegator: MemoListViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title = "메모"
        navigationItem.title = title
    }

    func showDetailViewController(with data: Memo?) {
        guard let splitViewController = splitViewController as? SplitView else {
            return
        }

        splitViewController.showDetailViewController(with: data)
    }

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
            right: horizontalMargin
        )
    }

    private func configureNavigationItem() {
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
