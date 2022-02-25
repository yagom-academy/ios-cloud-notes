//
//  SearchResultViewController.swift
//  CloudNotes
//
//  Created by 이승재 on 2022/02/25.
//

import UIKit

class SearchResultViewController: UITableViewController {

    // MARK: - Properties

    private var searchedNoteData = [Content]()

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }

    func setSearchedNoteData(_ data: [Content]) {
        self.searchedNoteData = data
        self.tableView.reloadData()
    }

    func selectedSearchedNote(at indexPath: IndexPath) -> Content {
        self.searchedNoteData[indexPath.row]
    }

    private func setUpTableView() {
        self.tableView.register(cellWithClass: NoteListCell.self)
    }
}

// MARK: - TableView DataSource

extension SearchResultViewController {

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: NoteListCell.self)
        cell.configureContent(for: searchedNoteData[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.searchedNoteData.count
    }
}
