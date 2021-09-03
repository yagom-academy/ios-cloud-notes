//
//  PrimaryViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class PrimaryViewController: UITableViewController {
    
    var primaryTableViewDataSource: PrimaryTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "메모"
        
        primaryTableViewDataSource = PrimaryTableViewDataSource()
        tableView.dataSource = primaryTableViewDataSource
        tableView.register(PrimaryTableViewCell.self, forCellReuseIdentifier: PrimaryTableViewCell.reuseIdentifier)
        
        tableView.rowHeight = 44
    }

}
