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
        setupSearchController()
        setupNavigationBar()
        setupNotification()
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewMemo))
    }
    
    @objc private func createNewMemo() {
        navigationItem.rightBarButtonItem?.isEnabled = false
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
        NotificationCenter.default.addObserver(self, selector: #selector(enableAddButton), name: .enableAddButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableAddButton), name: .disableAddButton, object: nil)
    }
}

//MARK: - extension TableView
extension ListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return MemoModel.shared.filteredList.count
        }
        return MemoModel.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memoCell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        memoCell.accessoryType = .disclosureIndicator
        if isFiltering() {
            memoCell.setUpMemoCell(MemoModel.shared.filteredList[indexPath.row])
        } else {
            memoCell.setUpMemoCell(MemoModel.shared.list[indexPath.row])
        }
        return memoCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFiltering() {
            MemoModel.shared.filteredIndex = indexPath.row
            let memo = MemoModel.shared.filteredList[indexPath.row]
            let originalIndex = MemoModel.shared.list.firstIndex(of: memo)
            delegate?.memoSelected(originalIndex)
            showDetailView()
            return
        }
        
        if indexPath.row == 0 {
            delegate?.memoSelected(indexPath.row)
            showDetailView()
            return
        }
        
        if let newMemo = MemoModel.shared.list.first,
           let _ = newMemo.content {
            delegate?.memoSelected(indexPath.row)
        } else {
            MemoModel.shared.delete(index: 0)
            delegate?.memoSelected(indexPath.row - 1)
        }
        
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

// MARK: - UISearchResultsUpdating Delegate
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let input = searchController.searchBar.text else {
            return
        }
        filterContentForSearchText(input)
    }
    
    private func searchBarIsEmpty() -> Bool {
        return navigationItem.searchController?.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        MemoModel.shared.filteredList = MemoModel.shared.list.filter({( memo : Memo) -> Bool in
            return (memo.content?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        
        self.tableView.reloadData()
    }
    
    private func isFiltering() -> Bool {
        return navigationItem.searchController?.isActive ?? false && !searchBarIsEmpty()
    }
}

// MARK:- notification selector method
extension ListViewController {
    @objc private func createMemo(_ notification: Notification) {
        if !isFiltering() {
            if let data = notification.userInfo as? [String: Int],
               let index = data["index"] {
                self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
    
    @objc private func updateMemo(_ notification: Notification) {
        if isFiltering() {
            if let index = MemoModel.shared.filteredIndex {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
        else {
            if let data = notification.userInfo as? [String: Int],
               let index = data["index"] {
                self.tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0), IndexPath(row: 0, section: 0)], with: .none)
            }
        }
    }
    
    @objc private func deleteMemo(_ notification: Notification) {
        if isFiltering() {
            if let index = MemoModel.shared.filteredIndex {
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        } else {
            if let data = notification.userInfo as? [String: Int],
               let index = data["index"] {
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
    
    @objc private func enableAddButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc private func disableAddButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension Notification.Name {
    static let createMemo = Notification.Name("createMemo")
    static let deleteMemo = Notification.Name("deleteMemo")
    static let updateMemo = Notification.Name("updateMemo")
    static let enableAddButton = Notification.Name("enableAddButton")
    static let disableAddButton = Notification.Name("disableAddButton")
}
