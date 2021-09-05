//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoListViewController: UIViewController{
    
    var memoList: [Memo] = []
    weak var splitViewDelegate: SplitViewDelegate?
    
    let tableView: UITableView = {
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
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = "메모"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func moveToDetail(indexPath: IndexPath) {
        let detailMemoViewController = DetailMemoViewController()
        detailMemoViewController.memo = memoList[indexPath.row]
        self.navigationController?.pushViewController(detailMemoViewController, animated: true)
    }
    
    @objc func addMemo() {
        let newMemo = Memo(title: "", body: "", date: 1234)
        self.memoList.append(newMemo)
        self.tableView.reloadData()
        splitViewDelegate?.addMemo(data: newMemo)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.splitViewDelegate?.isFisrtCellSelection = true
        self.splitViewDelegate?.selectCell(data: memoList[indexPath.row], index: indexPath)
    }
}

