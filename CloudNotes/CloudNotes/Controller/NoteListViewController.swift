//
//  PrimaryChildTableViewController.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/06.
//

import UIKit
import CoreData

class NoteListViewController: UITableViewController {
    private var notes: [Note] = []
    let cellIdentifier = "noteCell"
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        
        return app.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNotes()
        initTableView()
    }
    
    private func initTableView() {
        let notesTitle = "메모"
        title = notesTitle
        tableView.register(NoteCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        createNote()
        let newIndexPath = findNewNoteIndexPath()
        scrollDownToTableBottom(to: newIndexPath)
        showContentDetails(of: notes.last, at: newIndexPath)
    }
    
    private func findNewNoteIndexPath() -> IndexPath {
        let rowCount = notes.count
        
        if rowCount == 0 {
            return IndexPath(row: .zero, section: .zero)
        } else {
            let lastRowIndex = rowCount - 1
            return IndexPath(row: lastRowIndex, section: .zero)
        }
    }

    private func scrollDownToTableBottom(to bottomIndexPath: IndexPath) {
        tableView.scrollToRow(at: bottomIndexPath, at: .bottom, animated: true)
    }

    private func showContentDetails(of note: Note?, at indexPath: IndexPath) {
        guard let note = note else { return }
        
        let detailRootViewController = NoteDetailViewController()
        let detailViewController = UINavigationController(
            rootViewController: detailRootViewController)
        
        detailRootViewController.initContent(of: note, at: indexPath)
        detailRootViewController.delegate = self
        showDetailViewController(detailViewController, sender: self)
    }
}

extension NoteListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NoteCell,
              indexPath.row < notes.count else { return UITableViewCell() }

        cell.initCell(with: notes[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showContentDetails(of: notes[indexPath.row], at: indexPath)
    }
}

extension NoteListViewController: NoteUpdater {
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                fetchNotes()
            } catch {
                print(error)
            }
        }
    }
    
    func createNote() {
        let newNote = Note(context: context)
        newNote.title = String.empty
        newNote.body = String.empty
        newNote.lastModified = Date().timeIntervalSince1970
        saveContext()
    }
    
    func update(with noteData: Note, at indexPath: IndexPath) {

    }
    
    func fetchNotes() {
        do {
            notes = try context.fetch(Note.fetchRequest())
            self.tableView.reloadData()
        } catch {
            print("Data Not Found")
        }
    }
    
    func deleteNote(at indexPath: IndexPath) {
        
    }
}
