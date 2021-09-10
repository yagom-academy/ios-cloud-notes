//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class PrimaryViewController: UIViewController {
    private let tableView = UITableView()
    private let tableViewDataSource = MainVCTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: CellID.defaultCell.identifier)
        self.tableView.dataSource = tableViewDataSource
        self.tableView.delegate = self
        self.setNavigationBarItem()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
        self.tableView.frame = view.bounds
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}

extension PrimaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.giveDataToSecondaryVC(indexPath, tableView)
        self.splitViewController?.show(.secondary)
    }
    
    private func giveDataToSecondaryVC(_ indexPath: IndexPath, _ tableView: UITableView) {
        let secondVC = splitViewController?.viewController(for: .secondary) as? SecondaryViewController
        let lineBreaker = "\n"
        let emptyString = ""
        let transferedText = "\(MemoData.list?[indexPath.row].title ?? emptyString)" + lineBreaker + lineBreaker + "\(MemoData.list?[indexPath.row].body ?? emptyString)"
        let tableViewIndexPathHolder = TextViewRelatedDataHolder(indexPath: indexPath, tableView: tableView, textViewText: transferedText)
        secondVC?.configure(tableViewIndexPathHolder)
    }
}

extension PrimaryViewController {
    private func setNavigationBarItem() {
        let navigationBarTitle = "메모"
        self.title = navigationBarTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(didTabButton))
    }
    
    @objc func didTabButton() {
        let detailVC = SecondaryViewController()
        self.showDetailViewController(detailVC, sender: nil)
    }
}
