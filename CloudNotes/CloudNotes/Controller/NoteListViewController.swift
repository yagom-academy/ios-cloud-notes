//
//  NoteListViewController.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit

class NoteListViewController: UIViewController {
    private var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "cell",
          for: indexPath
        )
        return cell
    }
}
