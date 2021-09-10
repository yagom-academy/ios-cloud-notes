//
//  PrimaryChildTableViewController.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/06.
//

import UIKit

class PrimaryChildViewController: UITableViewController {
    private var notes: [Note]?
    let cellIdentifier = "notesCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        initNotes()
    }
    
    private func initTableView() {
        let notesTitle = "메모"
        title = notesTitle
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    
    private func initNotes() {
        let sampleDataFileName = "sample"
        let sampleData = NSDataAsset(name: sampleDataFileName)?.data
        let parsedData = sampleData.parse(type: [Note].self)
        
        switch parsedData {
        case .success(let parsedData):
            notes = parsedData
        case .failure(let error):
            print(error)
        }
    }
    
    @objc private func addButtonTapped() {
        addNewNote()
        let newIndexPath = findNewNoteIndexPath()
        scrollDownToTableBottom(to: newIndexPath)
        showContentDetails(of: notes?.last, at: newIndexPath)
    }

    private func addNewNote() {
        notes?.append(Note(title: String.empty,
                           body: String.empty,
                           lastModified: Date().timeIntervalSince1970))
        tableView.reloadData()
    }
    
    private func findNewNoteIndexPath() -> IndexPath {
        guard let rowCount = notes?.count else { return IndexPath(row: .zero, section: .zero) }
        let lastRowIndex = rowCount - 1
        
        return IndexPath(row: lastRowIndex, section: .zero)
    }

    private func scrollDownToTableBottom(to bottomIndexPath: IndexPath) {
        tableView.scrollToRow(at: bottomIndexPath, at: .bottom, animated: true)
    }

    private func showContentDetails(of note: Note?, at indexPath: IndexPath) {
        guard let note = note else { return }
        
        let detailRootViewController = SecondaryChildViewController()
        let detailViewController = UINavigationController(
            rootViewController: detailRootViewController)
        
        detailRootViewController.initContent(of: note, at: indexPath)
        detailRootViewController.delegate = self
        showDetailViewController(detailViewController, sender: self)
    }
}

extension PrimaryChildViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                as? NotesTableViewCell,
              let note = notes?[indexPath.row] else { return UITableViewCell() }
        
        cell.initCell(with: note)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showContentDetails(of: notes?[indexPath.row], at: indexPath)
    }
}

extension PrimaryChildViewController: NoteUpdater {
    func update(note: Note, at indexPath: IndexPath) {
        let index = indexPath.row
        notes?[index].title = note.title
        notes?[index].body = note.body
        notes?[index].lastModified = note.lastModified
        tableView.reloadData()
    }
}
