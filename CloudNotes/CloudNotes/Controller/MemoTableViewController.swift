//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

class MemoTableViewController: UITableViewController {
    private var memo = [Memo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellWithClass: MemoTableViewCell.self)
        fetchMemoData()
        configureNavigationBar()
        configureTableView()
    }
    
    private func fetchMemoData() {
        // TODO: Core Data create method
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
    private func configureTableView() {
        if self.splitViewController?.isCollapsed == false && memo.isEmpty == false {
            let initialIndexPath = IndexPath(row: 0, section: 0)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: initialIndexPath)
        }
        tableView.separatorInset = UIEdgeInsets.zero
    }
}

// MARK: - UITableViewDataSource

extension MemoTableViewController {
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

// MARK: - UITableViewDelegate

extension MemoTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = memo[indexPath.row]
        
        guard let memoSplitViewController = self.splitViewController as? MemoSplitViewController else {
            return
        }
        
        memoSplitViewController.showSecondaryView(with: data)
    }
}
