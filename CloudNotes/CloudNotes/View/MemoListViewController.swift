//
//  CloudNotes - MemoListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MemoListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewSetting()
        navigationItemSetting()
        
        configure()
        addSubView()
        autoLayout()
    }
    
    func viewSetting() {
        self.view.backgroundColor = .white
    }
    
    func navigationItemSetting() {
        self.navigationItem.title = "메모"
    }

    func configure() {
//        tableView.dataSource = self
//        tableView.rowHeight = 100
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func addSubView() {
        view.addSubview(tableView)
    }
    
    func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }
    
    
}

extension MemoListViewController: UITableViewDelegate {
    
    
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath)
        
        return cell
    }
    
    
    
}

