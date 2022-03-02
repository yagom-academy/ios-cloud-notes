//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class CloudNotesSplitViewController: UISplitViewController {
    
    // MARK: - properties
    
    let persistentManager = PersistentManager()
    let noteListViewController = NoteListViewController()
    let noteDetailViewController = NoteDetailViewController()
    var popoverController: UIPopoverPresentationController?
    var currentIndex = 0
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplitView()
        setupChildViewControllers()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let popoverController = popoverController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(
                x: UIScreen.main.bounds.width / 2,
                y: UIScreen.main.bounds.height / 2,
                width: 0,
                height: 0
            )
            popoverController.permittedArrowDirections = []
        }
    }
    
    // MARK: - Methods
    
    private func setupSplitView() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        
    }
    
    private func setupChildViewControllers() {
        noteListViewController.persistentManager = persistentManager
        noteListViewController.delegate = self
        noteDetailViewController.persistentManager = persistentManager
        noteDetailViewController.delegate = self
        
        setViewController(
          noteListViewController,
          for: .primary
        )
        setViewController(
          noteDetailViewController,
          for: .secondary
        )
    }
    
    private func showActivityView(note: Note, targetButton: UIBarButtonItem?) {
        let noteTextToShare = "\(note.title ?? "")\n\(note.content ?? "")"
        let activityViewController = UIActivityViewController(
            activityItems: [noteTextToShare],
            applicationActivities: nil
        )
        popoverController = activityViewController.popoverPresentationController
        popoverController?.sourceView = self.view
        
        if let targetButton = targetButton {
            popoverController?.barButtonItem = targetButton
        } else {
            popoverController?.permittedArrowDirections = []
            popoverController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.width / 2,
                y: UIScreen.main.bounds.height / 2,
                width: 0,
                height: 0
            )
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - NoteListView Delegate

extension CloudNotesSplitViewController: NoteListViewDelegate {
    func sharedNoteActionWithSwipe(index: Int) {
        let note = persistentManager.notes[index]
        showActivityView(note: note, targetButton: nil)
    }
    
    func deleteNoteActionWithSwipe(index: Int) {
        let note = persistentManager.notes[index]
        self.showDeleteAlert(message: "Do you want to delete?".localized) {
            self.noteListViewController.deleteNote(
                object: note,
                indexPath: IndexPath(row: index, section: 0)
            )
        }
    }
    
    func setupNotEmptyNoteContents() {
        noteDetailViewController.setupNotEmptyDetailView()
    }
    
    func setupEmptyNoteContents() {
        noteDetailViewController.setupEmptyDetailView()
    }
    
    func noteListView(didSeletedCell row: Int) {
        noteDetailViewController.setupDetailView(index: row)
        currentIndex = row
    }
}

// MARK: - NoteDetailView Delegate

extension CloudNotesSplitViewController: NoteDetailViewDelegate {
    func deleteNoteAction() {
        let note = persistentManager.notes[currentIndex]
        noteListViewController.showDeleteAlert(message: "Do you want to delete?".localized) {
            self.noteListViewController.deleteNote(
                object: note,
                indexPath: IndexPath(row: self.currentIndex, section: 0)
            )
        }
    }
    
    func sharedNoteAction(_ sender: UIBarButtonItem) {
        let note = persistentManager.notes[currentIndex]
        showActivityView(note: note, targetButton: sender)
    }
    
    func textViewDidChange(noteInformation: NoteInformation) {
        if currentIndex == 0 && noteInformation.title != "" {
            noteListViewController.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        noteListViewController.updateListView(index: currentIndex, noteInformation: noteInformation)
        currentIndex = 0

    }
}
