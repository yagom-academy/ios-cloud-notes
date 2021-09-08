//
//  ListTableViewController.swift
//  CloudNotes
//
//  Created by Ellen on 2021/09/03.
//

import UIKit

class ListViewController: UIViewController {
    private var tableView: UITableView!
    private var memo: [MemoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMemo()
        setUp()
    }
    
    private func setUp() {
        tableView = UITableView()
        view.addSubview(tableView)
        title = "메모"
        tableView.dataSource = self
        tableView.register(ListTableViewCell.classForCoder(), forCellReuseIdentifier: ListTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = (UIScreen.main.bounds.height) / 12
        NSLayoutConstraint.activate([
                                        tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                        tableView.rightAnchor.constraint(equalTo: view.rightAnchor)])
    }
    
    private func prepareMemo() {
        let jsonHandler = JSONHandler()
        guard let jsonData = JsonUtil.loadJsonData("sample") else { return }
        guard let data = jsonHandler.decode(with: jsonData, to: [MemoList].self) else { return }
        memo.append(contentsOf: data)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.cellIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        cell.setUpLabels(model: memo, indexPath: indexPath)
        cell.addSubViews()
        cell.setUpConstraints()
        return cell
    }
}
