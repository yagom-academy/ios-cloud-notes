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
    var activityViewPopover: UIPopoverPresentationController?
    var actionSheetPopover: UIPopoverPresentationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        detailRootViewController.alertDelegate = self
        showDetailViewController(detailViewController, sender: self)
    }
    
    func deleteNote(at indexPath: IndexPath) {
        noteManager.deleteNote(at: indexPath)
        splitViewController?.setViewController(nil, for: .secondary)
    }
}

// MARK: Pad Setting
extension NoteListViewController {
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)

        configurePadSetting(for: actionSheetPopover)
        configurePadSetting(for: activityViewPopover)
    }
    
    private func configurePadSetting(for popover: UIPopoverPresentationController?) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let splitView = splitViewController?.view {
                let newRect = CGRect(x: splitView.bounds.midX,
                                     y: splitView.bounds.midY,
                                     width: .zero,
                                     height: .zero)
                popover?.sourceView = splitView
                popover?.sourceRect = newRect
                popover?.permittedArrowDirections = []
            }
        }
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
            self.showDeleteAlert(of: indexPath)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let shareAction =  UIContextualAction(style: .normal, title: Swipe.share) { (_, _, _) in
            self.showActivityView(of: indexPath)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

// MARK: Alertable
extension NoteListViewController: Alertable {
    func showActionSheet(of indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: ActionSheet.title,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: ActionSheet.shareAction, style: .default) { _ in
            self.showActivityView(of: indexPath)
        }
        
        let deleteAction = UIAlertAction(title: ActionSheet.deleteAction, style: .destructive) { _ in
            self.showDeleteAlert(of: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: ActionSheet.cancelAction, style: .cancel)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        configurePadSetting(for: actionSheet.popoverPresentationController)
        actionSheetPopover = actionSheet.popoverPresentationController
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showActivityView(of indexPath: IndexPath) {
        let shareText: String = notes[indexPath.row].title
        let activityView = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        configurePadSetting(for: activityView.popoverPresentationController)
        activityViewPopover = activityView.popoverPresentationController
        
        self.present(activityView, animated: true, completion: nil)
    }
    
    func showDeleteAlert(of indexPath: IndexPath) {
        let alert = UIAlertController(title: Alert.title,
                                      message: Alert.message,
                                      preferredStyle: .alert)
  
        let cancelAction = UIAlertAction(title: Alert.cancelAction, style: .cancel)
        
        let deleteAction = UIAlertAction(title: Alert.deleteAction, style: .destructive) { _ in
            self.deleteNote(at: indexPath)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
