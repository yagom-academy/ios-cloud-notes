//
//  PrimaryTableViewController.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

class PrimaryTableViewController: UITableViewController {
    private var memo = [Memo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellWithClass: MemoTableViewCell.self)
        fetchMemoData()
        configureNavigationBar()
        configureTableView()
    }
    
    private func fetchMemoData() {
        guard let memoData = JSONConverter<[Memo]>().decode(from: "sample") else {
            return
        }
        
        memo = memoData
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
    private func configureTableView() {
        tableView.separatorInset = UIEdgeInsets.zero
    }
}

// MARK: - UITableViewDataSource

extension PrimaryTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MemoTableViewCell.self, for: indexPath)
        
        let data = memo[indexPath.row]
        cell.configureCellContent(from: data)
        
        return cell
    }
}
