//
//  PrimaryChildTableViewController.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/06.
//

import UIKit

class NoteListViewController: UITableViewController {
    private var notes: [Note] = []
    var noteManager = NoteManager()
    weak var alertDelegate: Alertable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertDelegate = splitViewController as? Alertable
        notes = noteManager.fetchNotes()
        initTableView()
        NotificationCenter.default
            .addObserver(self, selector: #selector(updateTableView), name: .noteNotification, object: nil)
    }
    
    private func initTableView() {
        title = NotesTable.navigationBarTitle
        tableView.register(NoteCell.self, forCellReuseIdentifier: NotesTable.cellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    
    @objc private func updateTableView(notification: Notification) {
        if let updatedNotes = notification.userInfo?["notes"] as? [Note] {
            notes = updatedNotes
            tableView.reloadData()
        }
    }
    
    @objc private func addButtonTapped() {
        noteManager.createNote()
        let newIndexPath = findNewNoteIndexPath()
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        showContentDetails(of: notes.last, at: newIndexPath)
    }
    
    private func findNewNoteIndexPath() -> IndexPath {
        let rowCount = notes.count
        
        if rowCount == .zero {
            return IndexPath(row: .zero, section: .zero)
        } else {
            let lastRowIndex = rowCount - 1
            return IndexPath(row: lastRowIndex, section: .zero)
        }
    }
    
    private func showContentDetails(of note: Note?, at indexPath: IndexPath) {
        guard let note = note else { return }
        
        let detailRootViewController = NoteDetailViewController()
        let detailViewController = UINavigationController(
            rootViewController: detailRootViewController)
        
        detailRootViewController.initContent(of: note, at: indexPath)
        detailRootViewController.noteDelegate = noteManager
        detailRootViewController.alertDelegate = alertDelegate
        showDetailViewController(detailViewController, sender: self)
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension NoteListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTable.cellIdentifier)
                as? NoteCell, indexPath.row < notes.count else { return UITableViewCell() }

        cell.initCell(with: notes[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showContentDetails(of: notes[indexPath.row], at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: Swipe.delete) { (_, _, _) in
            self.alertDelegate?.showDeleteAlert(of: indexPath) {
                self.noteManager.deleteNote(at: indexPath)
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let shareAction =  UIContextualAction(style: .normal, title: Swipe.share) { (_, _, _) in
            self.alertDelegate?.showActivityView(of: indexPath, noteTitle: self.notes[indexPath.row].title)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
