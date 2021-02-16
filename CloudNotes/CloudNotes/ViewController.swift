//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    lazy var addMemoButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpNavigationBar()
    }
    
    private func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.addSubview(tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = addMemoButton
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        cell.dateLabel.text = "testDate \(indexPath.row)"
        cell.predescriptionLabel.text = "testPredescription \(indexPath.row)"
        cell.titleLabel.text = "testTitleLabel \(indexPath.row)"
        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate {
    
}
