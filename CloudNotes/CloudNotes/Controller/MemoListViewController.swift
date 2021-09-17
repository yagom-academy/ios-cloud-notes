//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MemoListViewController: UIViewController {

    var memoList: [Memo] = []
    
    weak var delegate: MemoListDelegate?
    private var selectedIndexPath: IndexPath?
    private let coreDataManager = CoreDataManager.shared
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFirstMemoList()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubView()
        configureTableView()
        configureAutoLayout()
        configureNavigationItem()
    }
    
    private func configureFirstMemoList() {
        memoList = coreDataManager.fetchMemoList()
        if memoList.isEmpty {
            makeSample()
            for memo in memoList {
                coreDataManager.insertMemo(memo)
            }
            memoList = coreDataManager.fetchMemoList()
        }
    }
    
    private func makeSample() {
        guard let assetData = NSDataAsset.init(name: "sample") else { return }
        guard let memoData = ParsingManager.decodingModel(data: assetData.data, model: [Memo].self) else {
            return
        }
        memoList = memoData
    }
    
    private func configureAutoLayout() {
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
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    @objc func addMemo() {
        let newMemo = Memo(title: "", body: "", date: Date().timeIntervalSince1970)
        coreDataManager.insertMemo(newMemo)
        self.memoList.append(coreDataManager.fetchLastMemo())
        let addIndex = IndexPath(row: memoList.count-1, section: 0)
        self.tableView.reloadData()
        delegate?.showDetail(data: coreDataManager.fetchLastMemo(), index: addIndex)
    }
    
    func deleteMemo(index: IndexPath) {
        let deletedMemo = memoList[index.row]
        memoList.remove(at: index.row)
        
        guard let id = deletedMemo.identifier else {
            return
        }
        
        coreDataManager.delete(identifier: id)
        tableView.deleteRows(at: [index], with: .automatic)
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
        
        cell.configure(with: memoList[indexPath.row])
        
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            return .delete
        }
        return .none
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMemo(index: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.isFirstCellSelection = true
        self.selectedIndexPath = indexPath
        self.delegate?.showDetail(data: memoList[indexPath.row], index: indexPath)
    }
}
