//
//  PrimaryViewController.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit
import CoreData

protocol PrimaryListDelegate: AnyObject {
    func showSelectedDetail(by memo: Memorable)
}

class PrimaryViewController: UITableViewController {
    weak var rootViewDelegate: PrimaryListDelegate?
    private var selectedIndexPath: IndexPath?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate.listResource = readDataAsset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.title = "메모"
    
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
        rootViewDelegate?.showSelectedDetail(by: selectedMemo)
    }
}

extension PrimaryViewController {
    private func readDataAsset() -> [Memo] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let dataAsset = NSDataAsset(name: "sample") else {
            NSLog("에러처리 필요 - PrimaryViewController.readDataAsset : 파일 바인딩 실패")
            return []
        }
        do {
            let result = try decoder.decode([Memo].self, from: dataAsset.data)
            return result
        } catch {
            NSLog("에러처리 필요 - PrimaryViewController.readDataAsset : 디코딩 실패")
            return []
        }
    }
}
