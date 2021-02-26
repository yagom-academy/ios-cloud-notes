//
//  CloudNotes - ListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

protocol MemoSelectionDelegate: class {
    func memoSelected(_ memoIndex: Int)
}

final class ListViewController: UITableViewController {
    weak var delegate: MemoSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "MemoTableViewCell")
        MemoModel.shared.fetch()
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(moveToPostViewController))
    }
    
    @objc private func moveToPostViewController() {
        if let detailViewController = delegate as? DetailViewController,
           (traitCollection.horizontalSizeClass == .compact && traitCollection.userInterfaceIdiom == .phone) {
            let detailViewNavigationController = UINavigationController(rootViewController: detailViewController)
            splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
        }
    }
}

// MARK: - extension TableView
extension ListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoModel.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memoCell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        memoCell.accessoryType = .disclosureIndicator
        memoCell.setUpMemoCell(MemoModel.shared.list[indexPath.row])
        return memoCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.memoSelected(indexPath.row)
        
        if let detailViewController = delegate as? DetailViewController,
           (traitCollection.horizontalSizeClass == .compact && traitCollection.userInterfaceIdiom == .phone) {
            let detailViewNavigationController = UINavigationController(rootViewController: detailViewController)
            splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
        }
        
        UserDefaults.standard.set(indexPath.row, forKey: "lastMemoIndex")
    }
}

