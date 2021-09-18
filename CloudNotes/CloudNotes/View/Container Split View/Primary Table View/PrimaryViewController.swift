//
//  PrimaryViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit
import CoreData

protocol PrimaryTableViewDelegate: NSObject {
    func showSelectedDetail(at indexPath: IndexPath?, isShow: Bool)
}

class PrimaryViewController: UITableViewController {
    private var selectedIndexPath: IndexPath?
//    private let coreManager = MemoCoreDataManager.shared
    private let coreManager: MemoCoreDataManager
    weak var rootDelegate: PrimaryTableViewDelegate?
    
    init(coreManager: MemoCoreDataManager) {
        self.coreManager = coreManager
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        coreManager.readDataAsset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
        self.navigationItem.title = Strings.VCTitle.primary.description
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PrimaryTableViewCell.self, forCellReuseIdentifier: PrimaryTableViewCell.className)
    }
}

// MARK: - TableView DataSource
extension PrimaryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreManager.listCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrimaryTableViewCell.className,
                                                       for: indexPath) as? PrimaryTableViewCell else {
            return UITableViewCell()
        }
        let memo = coreManager[indexPath.row]
        cell.configure(by: memo)

        return cell
    }
}

// MARK: - TableView Delegate
extension PrimaryViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rootDelegate?.showSelectedDetail(at: indexPath, isShow: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: Strings.Alert.delete
                                                .description) { _, _, completion in
            self.askDeletingCellAlert(at: indexPath)
            completion(true)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}

// MARK: - Button & Alert Actions
extension PrimaryViewController {
    @objc private func addMemo() {
        let newIndexPath = IndexPath(row: 0, section: 0)
        coreManager.insertData(MemoData("", "", Date().timeIntervalSince1970, nil)) {
            self.tableView.reloadData()
        }
        self.rootDelegate?.showSelectedDetail(at: newIndexPath, isShow: true)
    }
    
    private func askDeletingCellAlert(at currentIndexPath: IndexPath) {
        let alert = UIAlertController(title: Strings.Alert.deleteTitle.description, message: Strings.Alert.deleteMessage.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Alert.cancel.description, style: .default))
        alert.addAction(UIAlertAction(title: Strings.Alert.delete.description, style: .destructive) { _ in
            self.deleteMemo(at: currentIndexPath)
        })
        self.present(alert, animated: true)
    }
    
    private func deleteMemo(at indexPath: IndexPath) {
        if let objectID = self.coreManager[indexPath.row].objectID {
            self.coreManager.deleteData(at: objectID) {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.rootDelegate?.showSelectedDetail(at: indexPath.row < self.coreManager.listCount ? indexPath : nil, isShow: false)
            }
        }
    }
}
