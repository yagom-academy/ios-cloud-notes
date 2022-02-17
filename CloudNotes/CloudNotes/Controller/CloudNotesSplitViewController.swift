//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class CloudNotesSplitViewController: UISplitViewController {
    
    // MARK: - properties
    let persistantManager = PersistantManager()
    var currentIndex = 0
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplitView()
        setupChildViewControllers()
    }
    
    private func setupSplitView() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        view.backgroundColor = .systemBackground
    }
    
    private func setupChildViewControllers() {
        let noteListViewController = NoteListViewController()
        noteListViewController.persistantManager = persistantManager
        noteListViewController.delegate = self
        
        let noteDetailViewController = NoteDetailViewController()
        noteDetailViewController.persistantManager = persistantManager
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
}

// MARK: - NoteListView Delegate

extension CloudNotesSplitViewController: NoteListViewDelegate {
    func setupNotEmptyNoteContents() {
        if let detailViewController = viewController(
            for: .secondary
        ) as? NoteDetailViewController {
            detailViewController.setupNotEmptyDetailView()
        }
    }
    
    func setupEmptyNoteContents() {
        if let detailViewController = viewController(
            for: .secondary
        ) as? NoteDetailViewController {
            detailViewController.setupEmptyDetailView()
        }
    }
    
    func noteListView(didSeletedCell row: Int) {
        if let detailViewController = viewController(
            for: .secondary
        ) as? NoteDetailViewController {
            detailViewController.setupDetailView(index: row)
            currentIndex = row
        }
    }
}

// MARK: - NoteDetailView Delegate

extension CloudNotesSplitViewController: NoteDetailViewDelegate {
    func deleteNoteAction() {
        let note = persistantManager.notes[currentIndex]
        if let listViewController = viewController(
            for: .primary
        ) as? NoteListViewController {
            listViewController.showDeleteAlert(message: "정말로 삭제하시겠어요?") {
                listViewController.deleteNote(object: note, indexPath: IndexPath(row: self.currentIndex, section: 0))
            }
        }
    }
    
    func sharedNoteAction(_ sender: UIBarButtonItem) {
        let note = persistantManager.notes[currentIndex]
        self.showActivityView(note: note, targetButton: sender)
    }
    
    func textViewDidChange(noteInformation: NoteInformation) {
        if let listViewController = viewController(
            for: .primary
        ) as? NoteListViewController {
            listViewController.updateListView(index: currentIndex, noteInformation: noteInformation)
        }
    }
}
