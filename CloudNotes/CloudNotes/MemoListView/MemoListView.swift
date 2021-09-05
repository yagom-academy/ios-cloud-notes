//
//  HeaderController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class MemoListView: UITableViewController {

    private let memoListDataSource = MemoListViewDataSource()
    private var memoListDelegator: MemoListViewDelegate?

    private let basicInset = UIEdgeInsets(
        top: .zero,
        left: .zero,
        bottom: .zero,
        right: .zero
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let ten: CGFloat = 10

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
            top: 0,
            left: ten,
            bottom: 0,
            right: -ten
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title = "메모"
        navigationController?.navigationItem.title = title

        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem = btn
    }

    func showDetailViewController(with data: Memo?) {
        guard let splitViewController = splitViewController as? SplitView else {
            return
        }

        splitViewController.showDetailViewController(with: data)
    }
}
