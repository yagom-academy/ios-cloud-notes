//
//  NoteListViewController.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/01.
//

import UIKit

final class NoteListViewController: UIViewController {
    private let noteTableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    let noteListViewModel: NoteListViewModel = NoteListViewModel()
    weak var noteDelegate: NoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationItem()
        configureConstraint()
        addNotification()
        
        noteListViewModel.notes.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.noteTableView.reloadSections(IndexSet(0...0), with: .automatic)
                self?.showFirstNote()
            }
        }
    }
    
    private func configureTableView() {
        self.noteTableView.dataSource = self
        self.noteTableView.delegate = self
        self.noteTableView.register(NoteListTableViewCell.self,
                                    forCellReuseIdentifier: NoteListTableViewCell.identifier)
        self.noteTableView.reloadData()
        self.noteTableView.showsVerticalScrollIndicator = false
    }
    
    private func configureConstraint() {
        noteTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteTableView)
        
        NSLayoutConstraint.activate([
            noteTableView.topAnchor.constraint(equalTo: view.topAnchor),
            noteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = NoteLiteral.navigationItemTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(didTapAddButton))
    }
    
    private func showFirstNote() {
        if noteListViewModel.isDataExist(), UITraitCollection.current.horizontalSizeClass == .regular {
            noteTableView.selectRow(at: [0, 0], animated: true, scrollPosition: .none)
            noteDelegate?.showDetailNote(self, at: [0, 0])
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeNote), name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDeleteNote), name: UITableView.selectionDidChangeNotification, object: nil)
    }
    
    @objc func didChangeNote(_ notification: Notification) {
        guard let editedNote = notification.object as? (note: String?, lastModifiedDate: Date?, indexPath: IndexPath?),
              let note = editedNote.note,
              let lastModifiedDate = editedNote.lastModifiedDate,
              let indexPath = editedNote.indexPath
        else { return }
        
        noteListViewModel.updateNote(note, lastModifiedDate, at: indexPath)
        updateCell(note, lastModifiedDate, at: indexPath)
    }
    
    @objc func didDeleteNote(_ notification: Notification) {
        guard let indexPath = notification.object as? IndexPath else { return }
        
        noteListViewModel.deleteNote(indexPath: indexPath)
    }
    
    @objc func didTapAddButton() {
        noteListViewModel.createNote()
        noteDelegate?.showDetailNote(self, at: [0, 0])
    }
    
    func updateCell(_ note: String, _ lastModifiedDate: Date, at indexPath: IndexPath) {
        guard let cell = noteTableView.cellForRow(at: indexPath) as? NoteListTableViewCell else { return }
        
        let separatedNotes = note.split(separator: NoteLiteral.LineBreak.Character, maxSplits: 1).map { (value) -> String in
            return String(value)
        }
        if separatedNotes.count == 0 {
            cell.update(title: NoteLiteral.defaultTitle, date: lastModifiedDate, body: NoteLiteral.defaultBody)
        } else if separatedNotes.count == 1 {
            cell.update(title: separatedNotes[NoteLiteral.titleIndex], date: lastModifiedDate, body: NoteLiteral.empty)
        } else {
            cell.update(title: separatedNotes[NoteLiteral.titleIndex], date: lastModifiedDate, body: separatedNotes[NoteLiteral.bodyIndex])
        }
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteListViewModel.getNumberOfNotes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteListTableViewCell.identifier, for: indexPath) as? NoteListTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(noteListViewModel.getNoteData(at: indexPath))
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        noteDelegate?.showDetailNote(self, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: NoteLiteral.deleteTitle) { action, view, completionHandler in
            let alert = UIAlertController(title: nil, message: NoteLiteral.deleteMessage, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NoteLiteral.cancelTitle, style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: NoteLiteral.deleteTitle, style: .destructive) { _ in
                self.noteListViewModel.deleteNote(indexPath: indexPath)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
            
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: NoteLiteral.shareTitle) { action, view, completionHandler in
            let shareNote = [self.noteListViewModel.getNote(at: indexPath)]
            let activityViewController = UIActivityViewController(activityItems: shareNote, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return false
    }
}
