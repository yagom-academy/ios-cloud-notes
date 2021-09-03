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
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.dataSource = tableViewDataSource
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: CellId.defaultCell.description)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.cellLayoutMarginsFollowReadableWidth = false

//        tableView.setAnchor(top: self.view.topAnchor,
//                            bottom: self.view.bottomAnchor,
//                            leading: self.view.leadingAnchor,
//                            trailing: self.view.trailingAnchor,
//                            layoutMargins: self.view.directionalLayoutMargins)
        tableView.frame = view.bounds
        
//        tableView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    
        
    }
    
}
