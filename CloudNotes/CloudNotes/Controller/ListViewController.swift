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
        setupNavigationBar()
        setupNotification()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewMemo))
    }
    
    @objc private func createNewMemo() {
        delegate?.memoSelected(nil)
        showDetailView()
    }
    
    private func showDetailView() {
        if let detailViewController = delegate as? DetailViewController,
           (traitCollection.horizontalSizeClass == .compact && traitCollection.userInterfaceIdiom == .phone) {
            let detailViewNavigationController = UINavigationController(rootViewController: detailViewController)
            splitViewController?.showDetailViewController(detailViewNavigationController, sender: nil)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(createMemo(_:)), name: .createMemo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMemo(_:)), name: .updateMemo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteMemo(_:)), name: .deleteMemo, object: nil)
    }
}

//MARK: - extension TableView
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
        showDetailView()
    }
    
    //MARK: tableView editingStyle delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        MemoModel.shared.delete(index: indexPath.row)
        self.delegate?.memoDeleted()
    }
}

extension ListViewController {
    @objc private func createMemo(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Int],
           let index = data["index"] {
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    @objc private func updateMemo(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Int],
           let index = data["index"] {
            self.tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0), IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    @objc private func deleteMemo(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Int],
           let index = data["index"] {
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

extension Notification.Name {
    static let createMemo = Notification.Name("createMemo")
    static let deleteMemo = Notification.Name("deleteMemo")
    static let updateMemo = Notification.Name("updateMemo")
}
