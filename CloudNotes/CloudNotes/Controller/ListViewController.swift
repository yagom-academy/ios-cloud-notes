//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ListViewController: UIViewController {
    
    private var memoList: [Memo] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setTableView()
    }
    
    private func setNavigation() {
        self.title = "메모"
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(goToAddMemoVeiwController))
    }
    
    @objc private func goToAddMemoVeiwController() {
       let addMemoViewController = AddMemoViewController()
        self.navigationController?.pushViewController(addMemoViewController, animated: true)
    }
    
    private func setTableView() {
        decodeMemo()
        configure()
        addSubView()
        setAutoLayout()
    }
    
    private func decodeMemo() {
        let jsonDecoder = JSONDecoder()
        guard let assetData: NSDataAsset = NSDataAsset(name: "sample") else {
            return
        }
        guard let memo = try? jsonDecoder.decode([Memo].self, from: assetData.data) else {
            return
        }
        memoList = memo
    }

    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func addSubView() {
        self.view.addSubview(tableView)
    }
    
    private func setAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        let memoListInfo = memoList[indexPath.row]
        cell.updateCell(info: memoListInfo)
        return cell
    }
}
