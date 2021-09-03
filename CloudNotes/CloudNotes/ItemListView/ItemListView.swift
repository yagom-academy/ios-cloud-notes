//
//  HeaderController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class ItemListView: UITableViewController {

    let itemListDataSource = ItemListViewDataSource()
    let itemListDelegator = ItemListViewDelegate()
    let basicInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)

    override func viewDidLoad() {
        let ten: CGFloat = 10

        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        tableView.register(
            ItemListViewCell.classForCoder(),
            forCellReuseIdentifier: ItemListViewCell.identifier
        )

        tableView.dataSource = itemListDataSource
        tableView.delegate = itemListDelegator

        tableView.separatorColor = .darkGray
        tableView.separatorInset = basicInset

        tableView.contentInset = UIEdgeInsets(top: 0, left: ten, bottom: 0, right: -ten)
    }
}
