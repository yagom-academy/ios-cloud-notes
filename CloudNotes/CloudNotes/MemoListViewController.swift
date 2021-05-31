//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 
import Foundation
import UIKit

class MemoListViewController: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setTableViewLayout()
        self.tableView.register(MemoListTableViewCell.classForCoder(),forCellReuseIdentifier:MemoListTableViewCell.identifier)
    }
    
    private func setTableViewLayout() {
        self.view.addSubview(tableView)
        let safeArea = self.view.safeAreaLayoutGuide
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
        ])
    }
    
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier : MemoListTableViewCell.identifier) as? MemoListTableViewCell else {
            
            return UITableViewCell()
        }
        cell.configure(with: MemoListTableViewCellProperty())
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    
}
