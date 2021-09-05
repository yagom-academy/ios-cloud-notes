//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
 let tableView = UITableView()
   let tableViewDataSource = MainVCTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(tableView)
        tableView.dataSource = tableViewDataSource
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: CellId.defaultCell.description)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.frame = view.bounds
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    
}
