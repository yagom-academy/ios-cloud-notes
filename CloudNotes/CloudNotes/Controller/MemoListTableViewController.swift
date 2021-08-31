//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoListTableViewController: UITableViewController, MemoContainer {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableViewConstraints()
        registerTableViewCell()
    }
    
}

extension MemoListTableViewController {
    func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtomTap))
    }
    
    @objc func addButtomTap() {
        
    }
}

extension MemoListTableViewController {
    func registerTableViewCell() {
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
    }
    
    func configureTableViewConstraints() {
        tableView.rowHeight = 100
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return memo.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier,
                                                       for: indexPath) as? MemoListTableViewCell else {
            fatalError()
        }
        
        return cell
    }
}
