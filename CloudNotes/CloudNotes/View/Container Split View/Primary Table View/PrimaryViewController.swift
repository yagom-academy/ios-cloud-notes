//
//  PrimaryViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit
import CoreData

protocol PrimaryListDelegate: AnyObject {
    func showSelectedDetail(by memo: MemoModel, showPage isShowing: Bool)
}

class PrimaryViewController: UITableViewController {
    private enum MemoTableStrings: CustomStringConvertible {
        case viewTitle
        case delete
        case cancel
        case assetSampleFileName
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
            case .assetSampleFileName:
                return "sample"
            case .askingDeleteTitle:
                return "진짜요?"
            case .askingDeleteMessage:
                return "정말로 삭제하시겠어요?"
            }
        }
    }
    weak var rootViewDelegate: PrimaryListDelegate?
    private var selectedIndexPath: IndexPath?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let coreManager = MemoCoreDataManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("fetch Data")
        appDelegate.listResource = coreManager.fetchData()
        if appDelegate.listResource.isEmpty {
            print("데이터가 없어서 Sample 데이터로 저장")
            appDelegate.listResource = readDataAsset()
            for data in appDelegate.listResource {
                coreManager.insertData(data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.title = MemoTableStrings.viewTitle.description
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PrimaryTableViewCell.self, forCellReuseIdentifier: PrimaryTableViewCell.className)
        
    }
}

// MARK: - TableView DataSource
extension PrimaryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.listResource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrimaryTableViewCell.className,
                                                       for: indexPath) as? PrimaryTableViewCell else {
            return UITableViewCell()
        }
        let memo = appDelegate.listResource[indexPath.row]
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
        let selectedMemo = appDelegate.listResource[indexPath.row]
        rootViewDelegate?.showSelectedDetail(by: selectedMemo, showPage: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedIndex = indexPath.row
        let deleteAction = UIContextualAction(style: .destructive, title: MemoTableStrings.delete.description) { _, _, completion in
            self.askDeletingCellAlert(at: selectedIndex)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension PrimaryViewController {
    private func askDeletingCellAlert(at currentIndex: Int) {
        let alert = UIAlertController(title: MemoTableStrings.askingDeleteTitle.description, message: MemoTableStrings.askingDeleteMessage.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: MemoTableStrings.cancel.description, style: .default))
        alert.addAction(UIAlertAction(title: MemoTableStrings.delete.description, style: .destructive) { _ in
            self.deleteMemo(at: currentIndex) {
                self.tableView.reloadData()
                let showingMemo = currentIndex < self.appDelegate.listResource.endIndex ? self.appDelegate.listResource[currentIndex] : self.appDelegate.listResource[self.appDelegate.listResource.index(before: currentIndex)]
                self.rootViewDelegate?.showSelectedDetail(by: showingMemo, showPage: false)
            }
        })
        self.present(alert, animated: true)
    }
    private func deleteMemo(at row: Int, completion: @escaping () -> Void) {
        if let deletingMemo = appDelegate.listResource[row] as? MemoData,
           let coreID = deletingMemo.objectID {
            if !coreManager.deleteData(objectID: coreID) {
                print("에러처리 필요 - PrimaryViewController.deleteMemo : 코어데이터에서 해당 셀 삭제 실패")
                return
            }
        }
        appDelegate.listResource.remove(at: row)
        completion()
    }
    
    private func readDataAsset() -> [MemoModel] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let dataAsset = NSDataAsset(name: MemoTableStrings.assetSampleFileName.description) else {
            NSLog("에러처리 필요 - PrimaryViewController.readDataAsset : 파일 바인딩 실패")
            return []
        }
        do {
            let result = try decoder.decode([MemoSample].self, from: dataAsset.data)
            return result
        } catch {
            NSLog("에러처리 필요 - PrimaryViewController.readDataAsset : 디코딩 실패")
            return []
        }
    }
}
