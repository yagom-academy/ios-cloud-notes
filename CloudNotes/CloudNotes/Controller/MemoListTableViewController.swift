//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoListTableViewController: UITableViewController, MemoContainer {
    
    let isCompact: Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableViewConstraints()
        registerTableViewCell()
    }
    
    init(isCompact: Bool) {
        self.isCompact = isCompact
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MemoListTableViewController {
    enum NameSpace {
        enum TableView {
            static let heightSize: CGFloat = 80
        }
        
        enum NavigationItem {
            static let title = "메모"
        }
    }
}

extension MemoListTableViewController {
    func configureNavigationBar() {
        navigationItem.title = NameSpace.NavigationItem.title
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
        tableView.rowHeight = NameSpace.TableView.heightSize
        tableView.separatorInset = UIEdgeInsets.zero
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
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: memo[indexPath.row])
        
        return cell
    }
}

extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if self.isCompact {
            
        }
        
    }
}
