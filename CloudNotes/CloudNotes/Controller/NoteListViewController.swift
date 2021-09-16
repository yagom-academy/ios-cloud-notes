//
//  PrimaryChildTableViewController.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/06.
//

import UIKit
import CoreData

class NoteListViewController: UITableViewController {
    private var noteManager = NoteManager()
    weak var alertDelegate: Alertable?
    private lazy var noteListDataSource = NoteListDataSource(noteManager: noteManager)

    override func viewDidLoad() {
        super.viewDidLoad()

        performFetch()
        setUpTableView()
    }

    private func setUpTableView() {
        title = NotesTable.navigationBarTitle
        noteManager.fetchedResultsController.delegate = self
        tableView.dataSource = noteListDataSource
        tableView.register(NoteCell.self, forCellReuseIdentifier: NotesTable.cellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }

    @objc private func addButtonTapped() {
        noteManager.createNote()
    }
    
    private func performFetch() {
        do {
            try noteManager.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    private func updateViewWhenNewNoteIsAdded(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        showContentDetails(at: indexPath)
    }

    private func showContentDetails(at indexPath: IndexPath) {
        let detailRootViewController = NoteDetailViewController()
        let detailViewController = UINavigationController(
            rootViewController: detailRootViewController)

        let note = noteManager.fetchedResultsController.object(at: indexPath)

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
            let note = self.noteManager.fetchedResultsController.object(at: indexPath)
            let noteTitle = note.title
            self.alertDelegate?.showActivityView(of: indexPath, noteTitle: noteTitle, sender: .cellSwipe)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
}

extension NoteListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            updateViewWhenNewNoteIsAdded(at: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
