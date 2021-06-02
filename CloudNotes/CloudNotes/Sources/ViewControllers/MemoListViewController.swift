//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/02.
//

import UIKit

final class MemoListViewController: UIViewController {

    private let tableView = UITableView()
    private var memos = [Memo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(MemoCell.self, forCellReuseIdentifier: "memoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}

extension MemoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
    }

}
