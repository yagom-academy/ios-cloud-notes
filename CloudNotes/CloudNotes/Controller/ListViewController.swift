//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol ListViewDelegate: AnyObject {
    func didTapListCell(memo: Memo?, selectedIndex: Int)
    func didTapAddButton()
}

final class ListViewController: UIViewController {
    
    weak var listViewDelegate: ListViewDelegate?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        MemoData.shared.read()
        setNavigation()
        setTableView()
    }
    
    private func setNavigation() {
        self.title = "메모"
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(goToAddVeiwController))
    }
    
    @objc private func goToAddVeiwController() {
        listViewDelegate?.didTapAddButton()
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        addSubview()
        setAutoLayout()
    }

    private func addSubview() {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let memo = MemoData.shared.list[indexPath.row]
        listViewDelegate?.didTapListCell(memo: memo, selectedIndex: indexPath.row)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let memoList = MemoData.shared.list
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        let memoList = MemoData.shared.list
        let memoListInfo = memoList[indexPath.row]
        cell.update(info: memoListInfo)
        return cell
    }
}
