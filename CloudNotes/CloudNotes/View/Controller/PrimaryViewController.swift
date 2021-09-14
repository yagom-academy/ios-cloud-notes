//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class PrimaryViewController: UIViewController, CoreDataUsable {
    private let tableView = UITableView()
    private let tableViewDataSource = MainVCTableViewDataSource()
    private let context = MemoDataManager.context
    private var memos = MemoDataManager.memos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - TableView property and Method
        self.view.addSubview(tableView)
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: CellID.defaultCell.identifier)
        self.tableView.dataSource = tableViewDataSource
        self.tableView.delegate = self
        self.fetchCoreDataItems(context, tableView)
        
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
extension PrimaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.giveDataToSecondaryVC(indexPath, tableView)
        deselectCurrentCell(tableView)
        self.splitViewController?.show(.secondary)
    }
    
    private func giveDataToSecondaryVC(_ indexPath: IndexPath, _ tableView: UITableView) {
        let secondVC = splitViewController?.viewController(for: .secondary) as? SecondaryViewController
        
        let lineBreaker = "\n"
        let transferedText = "\(self.memos[indexPath.row].title ?? "")" + lineBreaker + "\(self.memos[indexPath.row].body ?? "")"
        let tableViewIndexPathHolder = TextViewRelatedDataHolder(indexPath: indexPath, tableView: tableView, textViewText: transferedText)
        secondVC?.configure(tableViewIndexPathHolder)
    }
    
    private func deselectCurrentCell(_ tableView: UITableView) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = [UIContextualAction(style: .destructive,
                                          title: "Delete",
                                          handler: { [weak self] action, view, completionHandler in
                                            let memoToRemove = self?.memos[indexPath.row]
                                            self?.deleteCoreData(self?.context ?? NSManagedObjectContext(), memoToRemove ?? NSManagedObject())
                                            self?.saveCoreData(self?.context ?? NSManagedObjectContext())
                                            self?.fetchCoreDataItems(self?.context ?? NSManagedObjectContext(), tableView)
                                            self?.memos.remove(at: indexPath.row)
                                          }),
                       UIContextualAction(style: .normal, title: "share", handler: { action, view, completionHandler in
                        print("share action구현하기 ")
                       })]
        
        return UISwipeActionsConfiguration(actions: actions)
    }
}

//MARK:- NavigationBar related Method
extension PrimaryViewController {
    private func setNavigationBarItem() {
        let navigationBarTitle = "메모"
        self.title = navigationBarTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTabButton))
    }
    
    @objc func didTabButton() {
        let newMemo = Memo(context: self.context)
        memos.append(newMemo)
        self.saveCoreData(context)
        
        guard let secondVC = self.splitViewController?.viewController(for: .secondary) as? SecondaryViewController else {
            return
        }
        
        let totalCell = tableView.numberOfRows(inSection: .zero)
        let newIndexPath = IndexPath(row: totalCell, section: .zero)
        
        let emptyHolder = TextViewRelatedDataHolder(indexPath: newIndexPath, tableView: tableView, textViewText: nil)
        secondVC.configure(emptyHolder)
        
        self.fetchCoreDataItems(context, tableView)
        self.splitViewController?.show(.secondary)
    }
}
