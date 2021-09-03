//
//  HeaderController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class ItemListView: UITableViewController {

    let itemListDataSource = ItemListViewDataSource()
    var itemListDelegator: ItemListViewDelegate?

    let basicInset = UIEdgeInsets(
        top: .zero,
        left: .zero,
        bottom: .zero,
        right: .zero
    )
    var isClicked = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let ten: CGFloat = 10
        itemListDelegator = ItemListViewDelegate(owner: self)

        tableView.register(
            ItemListViewCell.classForCoder(),
            forCellReuseIdentifier: ItemListViewCell.identifier
        )

        tableView.dataSource = itemListDataSource
        tableView.delegate = itemListDelegator

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

        isClicked = false
    }

    func showDetailViewController(with data: Memo) {
        guard isClicked == false,
              let splitViewController = splitViewController,
              let secondary = splitViewController.viewController(for: .secondary) as? ItemDetailView else {
            return
        }

        isClicked = true
        secondary.configure(data)

        if AppState.isCompactSize {
            splitViewController.showDetailViewController(
                secondary,
                sender: data
            )
        } else {
            splitViewController.show(.secondary)
        }
    }
}
