//
//  PrimaryChildTableViewController.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/06.
//

import UIKit

class NoteListViewController: UITableViewController {
    var noteManager = NoteManager()
    weak var alertDelegate: Alertable?
    lazy var noteListDataSource = NoteListDataSource(noteManager: noteManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertDelegate = splitViewController as? Alertable
        initTableView()
        NotificationCenter.default
            .addObserver(self, selector: #selector(updateTableView), name: .noteNotification, object: nil)
    }
    
    private func initTableView() {
        title = NotesTable.navigationBarTitle
        tableView.dataSource = noteListDataSource
        tableView.register(NoteCell.self, forCellReuseIdentifier: NotesTable.cellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    
    @objc private func updateTableView(notification: Notification) {
        tableView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        noteManager.createNote()
        let newIndexPath = findNewNoteIndexPath()
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        showContentDetails(at: newIndexPath)
    }
    
    private func findNewNoteIndexPath() -> IndexPath {
        let rowCount = noteManager.count
        
        if rowCount == .zero {
            return IndexPath(row: .zero, section: .zero)
        } else {
            let lastRowIndex = rowCount - 1
            return IndexPath(row: lastRowIndex, section: .zero)
        }
    }
    
    private func showContentDetails(at indexPath: IndexPath) {
        let detailRootViewController = NoteDetailViewController()
        let detailViewController = UINavigationController(
            rootViewController: detailRootViewController)
        
        guard let note = noteManager.fetchNote(at: indexPath.row) else { return }
        
        detailRootViewController.initContent(of: note, at: indexPath)
        detailRootViewController.noteDelegate = noteManager
        detailRootViewController.alertDelegate = alertDelegate
        showDetailViewController(detailViewController, sender: self)
    }
}

// MARK: UITableViewDelegate
extension NoteListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showContentDetails(at: indexPath)
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
            let noteTitle = self.noteManager.fetchNote(at: indexPath.row)?.title ?? String.empty
            self.alertDelegate?.showActivityView(of: indexPath, noteTitle: noteTitle)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
