//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

class PrimaryViewController: UIViewController {
    private let tableView = UITableView()
    private let tableViewDataSource = MainVCTableViewDataSource()
    private let context: NSManagedObjectContext = { () -> NSManagedObjectContext in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
    
    var memos: [Memo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - TableView property and Method
        self.view.addSubview(tableView)
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: CellID.defaultCell.identifier)
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
extension PrimaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.giveDataToSecondaryVC(indexPath, tableView)
        self.splitViewController?.show(.secondary)
    }
    
    private func giveDataToSecondaryVC(_ indexPath: IndexPath, _ tableView: UITableView) {
        let secondVC = splitViewController?.viewController(for: .secondary) as? SecondaryViewController
        let lineBreaker = "\n"
        let transferedText = "\(MemoData.list[indexPath.row].title)" + lineBreaker + lineBreaker + "\(MemoData.list[indexPath.row].body)"
        let tableViewIndexPathHolder = TextViewRelatedDataHolder(indexPath: indexPath, tableView: tableView, textViewText: transferedText)
        secondVC?.configure(tableViewIndexPathHolder)
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

extension PrimaryViewController {
    //MARK: - Fetch CoreData Method
    func fetchCoreDataItems() {
        do {
            self.memos = try self.context.fetch(Memo.fetchRequest())
        } catch {
            print(CoreDataError.fetchError.errorDescription)
        }
    }
}

enum CoreDataError: Error, LocalizedError {
    case fetchError
    case saveError
    case deletError
    case updateError
    
    var errorDescription: String? {
        switch self {
        case .fetchError:
            return "fetch에 실패했습니다."
        case .saveError:
            return "save에 실패했습니다."
        case .deletError:
            return "delet에 실패했습니다."
        case .updateError:
            return "update에 실패했습니다."
        }
    }
}
