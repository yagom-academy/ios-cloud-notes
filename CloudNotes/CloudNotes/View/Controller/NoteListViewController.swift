//
//  NoteList.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteListViewController: UIViewController {
    private let noteListViewModel = NoteManager()
    var noteDelegate: NoteDelegate?
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.showsVerticalScrollIndicator = false
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfiguration()
        setConstraint()
    }
    
    @objc private func addNote() {
        // TODO: - 메모 추가
    }
    
    private func setConfiguration() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteListCell.self, forCellReuseIdentifier: "NoteCell")
    }
    
    private func setConstraint() {
        self.view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListViewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteListCell else { return UITableViewCell() }
        cell.noteData = noteListViewModel.dataAtIndex(indexPath.row)

        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteDelegate?.deliverToDetail(noteListViewModel.dataAtIndex(indexPath.row))
    }
}
