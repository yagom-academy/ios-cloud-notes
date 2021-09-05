//
//  HeaderController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class ItemListView: UITableViewController {

    private let itemListDataSource = ItemListViewDataSource()
    private var itemListDelegator: ItemListViewDelegate?

    private let basicInset = UIEdgeInsets(
        top: .zero,
        left: .zero,
        bottom: .zero,
        right: .zero
    )
    private var isClicked = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let ten: CGFloat = 10

        itemListDelegator = ItemListViewDelegate(owner: self)
        tableView.dataSource = itemListDataSource
        tableView.delegate = itemListDelegator
        tableView.register(
            ItemListViewCell.classForCoder(),
            forCellReuseIdentifier: ItemListViewCell.identifier
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

        isClicked = false
        navigationController?.navigationItem.title = title

        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem = btn
    }

    func showDetailViewController(with data: Memo?) {
        guard isClicked == false,
              let splitViewController = splitViewController as? SplitView else {
            return
        }

        isClicked = true
        splitViewController.sendDataToDetailVC(data)
    }
}
