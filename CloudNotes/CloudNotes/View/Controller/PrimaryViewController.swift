//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

protocol CoreDataUsable {
    func fetchCoreDataItems(_ context: NSManagedObjectContext, _ tableview: UITableView)
}

extension CoreDataUsable {
    func fetchCoreDataItems(_ context: NSManagedObjectContext, _ tableview: UITableView) {
        do {
            MemoDataManager.memos = try context.fetch(Memo.fetchRequest())
            DispatchQueue.main.async {
                tableview.reloadData()
            }
        } catch {
            print(CoreDataError.fetchError.errorDescription)
        }
    }
}

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
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
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
        guard let secondVC = self.splitViewController?.viewController(for: .secondary) as? SecondaryViewController else {
            return
        }
        let emptyHolder = TextViewRelatedDataHolder(indexPath: nil, tableView: nil, textViewText: nil)
        secondVC.configure(emptyHolder)
        self.splitViewController?.show(.secondary)
    }
}
