//
//  HeaderController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class ItemListView: UITableViewController {

    let itemListDataSource = ItemListViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
        tableView.register(
            ItemListViewCell.classForCoder(),
            forCellReuseIdentifier: ItemListViewCell.identifier
        )
        
        tableView.dataSource = itemListDataSource
        
    }
}
