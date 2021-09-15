//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class MemoListViewController: UIViewController, CoreDataUsable {
    private let tableView = UITableView()
    private let tableViewDataSource = MemoListTableViewDataSource()
    private let context = MemoDataManager.context
    private var memos = MemoDataManager.memos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - TableView property and Method
        self.view.addSubview(tableView)
        self.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: CellID.defaultCell.identifier)
        self.tableView.dataSource = tableViewDataSource
        self.tableView.delegate = self
        
        //MARK: - NavigationBar Style Setting
        self.setNavigationBarItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
        self.tableView.frame = view.bounds
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK: - TablviewDelegate Method
extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.giveDataToSecondaryVC(indexPath, tableView)
        deselectCurrentCell(tableView)
        self.splitViewController?.show(.secondary)
    }
    
    private func giveDataToSecondaryVC(_ indexPath: IndexPath, _ tableView: UITableView) {
        let secondVC = splitViewController?.viewController(for: .secondary) as? MemoDetailViewController
        
        let transferedText = "\(self.memos[indexPath.row].title ?? "")" + "\(self.memos[indexPath.row].body ?? "")"
        let tableViewIndexPathHolder = TextViewRelatedDataHolder(indexPath: indexPath, tableView: tableView, textViewText: transferedText)
        secondVC?.configure(tableViewIndexPathHolder)
    }
    
    private func deselectCurrentCell(_ tableView: UITableView) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Mark: Options after cell swipping
        let actions = [
            UIContextualAction(
                style: .destructive,
                title: SelectOptions.delete.literal,
                handler: { [weak self] action, view, completionHandler in
                    guard let `self` = self else {
                        return
                    }
                    let memoToRemove = self.memos[indexPath.row]
                    self.deleteCoreData(self.context, memoToRemove)
                    self.saveCoreData(self.context)
                    self.fetchCoreDataItems(self.context, tableView)
                    self.memos.remove(at: indexPath.row)
                }),
            UIContextualAction(
                style: .normal,
                title: SelectOptions.share.literal,
                handler: { action, view, completionHandler in
                    print("share action구현하기 ")
                })
        ]
        
        return UISwipeActionsConfiguration(actions: actions)
    }
}

//MARK:- NavigationBar related method
extension MemoListViewController {
    private func setNavigationBarItem() {
        let navigationBarTitle = "메모"
        self.title = navigationBarTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTabAddButton))
    }
    
    //MARK: Add new memo in coredata button
    @objc func didTabAddButton() {
        let todayDate = Date().makeCurrentDateInt64Data()
        let newMemo = Memo(context: self.context)
        newMemo.lastModifiedDate = todayDate
        
        self.memos.append(newMemo)
        self.saveCoreData(context)
        
        guard let secondVC = self.splitViewController?.viewController(for: .secondary) as? MemoDetailViewController else {
            return
        }
        
        let totalRows = self.tableView.numberOfRows(inSection: .zero)
        let newIndexPath = IndexPath(row: totalRows, section: .zero)
        let emptyHolder = TextViewRelatedDataHolder(indexPath: newIndexPath, tableView: tableView, textViewText: nil)
        secondVC.configure(emptyHolder)
        
        self.fetchCoreDataItems(context, tableView)
        self.splitViewController?.show(.secondary)
    }
}
