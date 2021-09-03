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

    func showDetailViewController(with data: Memo) {
        guard let splitViewController = splitViewController,
              let secondary = splitViewController.viewController(for: .secondary) as? ItemDetailView else {
            return
        }

        secondary.configure(data.title)

        if UITraitCollection.current.horizontalSizeClass == .compact {
            super.showDetailViewController(
                secondary,
                sender: data
            )

        } else {
            splitViewController.show(.secondary)
            secondary.configure(data.title)
        }
    }
}
