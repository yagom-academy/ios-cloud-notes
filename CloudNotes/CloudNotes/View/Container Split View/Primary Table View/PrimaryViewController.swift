//
//  PrimaryViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit
import CoreData

protocol PrimaryListDelegate: AnyObject {
    func showSelectedDetail(by memo: MemoModel, at indexPath: IndexPath, showPage isShowing: Bool)
    func dismissDetail()
}

class PrimaryViewController: UITableViewController {
    private enum MemoTableStrings: CustomStringConvertible {
        case viewTitle
        case delete
        case cancel
        case askingDeleteTitle
        case askingDeleteMessage
        
        var description: String {
            switch self {
            case .viewTitle:
                return "메모"
            case .delete:
                return "삭제"
            case .cancel:
                return "취소"
            case .askingDeleteTitle:
                return "진짜요?"
            case .askingDeleteMessage:
                return "정말로 삭제하시겠어요?"
            }
        }
    }
    private var selectedIndexPath: IndexPath?
//    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let rootDelegate: SplitViewController
    private let coreManager = MemoCoreDataManager.shared
    
    init(rootDelegate: SplitViewController) {
        self.rootDelegate = rootDelegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("fetch Data")
        rootDelegate.listResource = coreManager.fetchData()
        if rootDelegate.listResource.isEmpty {
            print("데이터가 없어서 Sample 데이터로 저장")
            rootDelegate.listResource = rootDelegate.readDataAsset()
            for data in rootDelegate.listResource {
                coreManager.insertData(data)
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
        self.navigationItem.title = MemoTableStrings.viewTitle.description
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PrimaryTableViewCell.self, forCellReuseIdentifier: PrimaryTableViewCell.className)
        
    }
}

// MARK: - TableView DataSource
extension PrimaryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootDelegate.listResource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrimaryTableViewCell.className,
                                                       for: indexPath) as? PrimaryTableViewCell else {
            return UITableViewCell()
        }
        let memo = rootDelegate.listResource[indexPath.row]
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
        let selectedMemo = rootDelegate.listResource[indexPath.row]
        rootDelegate.showSelectedDetail(by: selectedMemo, at: indexPath, showPage: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: MemoTableStrings.delete.description) { _, _, completion in
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
    @objc
    private func addMemo() {
        let newMemo = MemoData("", "", 0, nil)
        let newIndexPath = IndexPath(row: 0, section: 0)
        rootDelegate.listResource.insert(newMemo, at: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        rootDelegate.showSelectedDetail(by: newMemo, at: newIndexPath, showPage: true)
    }
    
    private func askDeletingCellAlert(at currentIndexPath: IndexPath) {
        let alert = UIAlertController(title: MemoTableStrings.askingDeleteTitle.description, message: MemoTableStrings.askingDeleteMessage.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: MemoTableStrings.cancel.description, style: .default))
        alert.addAction(UIAlertAction(title: MemoTableStrings.delete.description, style: .destructive) { _ in
            self.rootDelegate.deleteMemo(at: currentIndexPath) { indexPath in
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        })
        self.present(alert, animated: true)
    }
}
