//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 
import Foundation
import UIKit

class MemoListViewController: UIViewController {
    
    let tableView = UITableView()
    var memoSplitViewController: MemoSplitViewController?
    var horizontalSizeClass: UIUserInterfaceSizeClass?
    lazy var rightNvigationItem: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addNewMemo), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpTableView()
        setUpNavigationBar()
    }
    
    @objc private func addNewMemo() {
        JsonDataCache.shared.decodedJsonData.insert(Memo(title: "", body: ""), at: 0)
        tableView.reloadData()
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNvigationItem)
        self.navigationItem.title = "메모"
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func setUpTableView() {
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(MemoListTableViewCell.classForCoder(),forCellReuseIdentifier:MemoListTableViewCell.identifier)
        self.setTableViewLayout()
    }
    
    private func setTableViewLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
        ])
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JsonDataCache.shared.decodedJsonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier : MemoListTableViewCell.identifier) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: JsonDataCache.shared.decodedJsonData[indexPath.row])
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoSplitViewController = memoSplitViewController else {
            return
        }
        memoSplitViewController.detail.configure(with: JsonDataCache.shared.decodedJsonData[indexPath.row], indexPath: indexPath)
        memoSplitViewController.showDetailViewController(UINavigationController(rootViewController: memoSplitViewController.detail), sender: nil)        
    }
}

