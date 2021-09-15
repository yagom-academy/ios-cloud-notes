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
    var activityViewPopover: UIPopoverPresentationController?
    var actionSheetPopover: UIPopoverPresentationController?
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        
        return app.persistentContainer.viewContext
    }
    
    internal func showActivityView(of indexPath: IndexPath) {
        let shareText: String = notes[indexPath.row].title
        var shareObject = [Any]()
        shareObject.append(shareText)
        let activityView = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let splitView = splitViewController?.view {
                let newRect = CGRect(x: splitView.bounds.midX, y: splitView.bounds.midY, width: 0, height: 0)
                activityView.popoverPresentationController?.sourceView = splitView
                activityView.popoverPresentationController?.sourceRect = newRect
                activityView.popoverPresentationController?.permittedArrowDirections = []
            }
        }

        activityViewPopover = activityView.popoverPresentationController
        self.present(activityView, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)

        guard let splitView = splitViewController?.view else { return }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let newRect = CGRect(x: splitView.bounds.midY, y: splitView.bounds.midX, width: 0, height: 0)
            activityViewPopover?.sourceRect = newRect
            actionSheetPopover?.sourceRect = newRect
        }
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
        detailRootViewController.alertDelegate = self
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
    
    func updateNote(at indexPath: IndexPath,
                    with noteData: (title: String, body: String, lastModified: Double)) {
        let noteToUpdate = notes[indexPath.row]
        noteToUpdate.title = noteData.title
        noteToUpdate.body = noteData.body
        noteToUpdate.lastModified = noteData.lastModified
        
        saveContext()
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
        let noteToDelete = notes[indexPath.row]
        context.delete(noteToDelete)
        saveContext()
        splitViewController?.setViewController(nil, for: .secondary)
    }
}

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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let splitView = splitViewController?.view {
                let newRect = CGRect(x: splitView.bounds.midX, y: splitView.bounds.midY, width: 0, height: 0)
                actionSheet.popoverPresentationController?.sourceView = splitView
                actionSheet.popoverPresentationController?.sourceRect = newRect
                actionSheet.popoverPresentationController?.permittedArrowDirections = []
            }
        }
        
        actionSheetPopover = actionSheet.popoverPresentationController
        self.present(actionSheet, animated: true, completion: nil)
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
