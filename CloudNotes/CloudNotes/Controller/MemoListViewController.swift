//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoListViewController: UIViewController{
    
    var memoList: [Memo] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
        return tableView
    }()
    
    func makeTest() {
        guard let assetData = NSDataAsset.init(name: "sample") else { return }
        guard let memoData = ParsingManager.decodingModel(data: assetData.data, model: [Memo].self) else {
            return
        }
        memoList = memoData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        configureTableView()
        ConfigureAutoLayout()
        configureNavigationItem()
        makeTest()
    }
    
    private func ConfigureAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = "메모"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = memoList[indexPath.row].title
        cell.dateLabel.text = memoList[indexPath.row].date.description
        cell.shortDiscriptionLabel.text = memoList[indexPath.row].body
        
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

