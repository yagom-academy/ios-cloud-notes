//
//  NoteListViewController.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit

class NoteListViewController: UIViewController {
    var noteDataSource: CloudNotesDataSource?
    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        guard let noteDataSource = noteDataSource else {
            return
        }
        tableView.dataSource = noteDataSource
        tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: NoteListCell.identifier
        )
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
