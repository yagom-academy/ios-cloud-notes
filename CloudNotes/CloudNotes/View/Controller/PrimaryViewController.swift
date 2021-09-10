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
        view.addSubview(tableView)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: CellID.defaultCell.identifier)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        setNavigationBarItem()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.frame = view.bounds
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension PrimaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        giveDataToSecondaryVC(indexPath, tableView)
        splitViewController?.show(.secondary)
    }
    
    private func giveDataToSecondaryVC(_ indexPath: IndexPath, _ tableView: UITableView) {
        let secondVC = splitViewController?.viewController(for: .secondary) as? SecondaryViewController
        let lineBreaker = "\n"
        let emptyString = ""
        let transferedText = "\(MemoData.list?[indexPath.row].title ?? emptyString)" + lineBreaker + lineBreaker + "\(MemoData.list?[indexPath.row].body ?? emptyString)"
        let tableViewIndexPathHolder = TableViewIdexPathHolder(indexPath: indexPath, tableView: tableView, textViewText: transferedText)
        secondVC?.configure(tableViewIndexPathHolder)
    }
}

extension PrimaryViewController {
    private func setNavigationBarItem() {
        let navigationBarTitle = "메모"
        title = navigationBarTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(didTabButton))
    }
    
    @objc func didTabButton() {
        let detailVC = SecondaryViewController()
        showDetailViewController(detailVC, sender: nil)
    }
}
