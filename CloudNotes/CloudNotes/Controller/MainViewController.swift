//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
   let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // 배경색
        tableView.backgroundColor = .systemGray
        view.addSubview(tableView)
        SetLayout.setupTableView(tableView, self.view)
 
    }

}
