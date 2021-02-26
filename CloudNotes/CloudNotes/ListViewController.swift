//
//  CloudNotes - ListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

protocol MemoUpdateDelegate: class {
    func memoSelected(_ memoIndex: Int?)
    func memoDeleted()
}

final class ListViewController: UITableViewController {
    weak var delegate: MemoUpdateDelegate?
    
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
        delegate?.memoSelected(nil)
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
    }
    
    //MARK: tableView editingStyle delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        MemoModel.shared.delete(index: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        self.delegate?.memoDeleted()
    }
}

//MARK: MemoListUpdateDelegate
extension ListViewController: MemoListUpdateDelegate {
    func deleteMemo(_ memoIndex: Int) {
        self.tableView.deleteRows(at: [IndexPath(row: memoIndex, section: 0)], with: .automatic)
    }
    
    func updateMemo(_ memoIndex: Int) {
        self.tableView.moveRow(at: IndexPath(row: memoIndex, section: 0), to: IndexPath(row: 0, section: 0))
        self.tableView.reloadRows(at: [IndexPath(row: memoIndex, section: 0), IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func saveMemo(_ memoIndex: Int) {
        self.tableView.insertRows(at: [IndexPath(row: memoIndex, section: 0)], with: .automatic)
    }
}
