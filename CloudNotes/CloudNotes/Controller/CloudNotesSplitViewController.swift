//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class CloudNotesSplitViewController: UISplitViewController {
    
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
        let noteDataSource = CloudNotesDataSource()
        let noteListViewController = NoteListViewController()
        noteListViewController.delegate = self
        noteListViewController.noteDataSource = noteDataSource
        let noteDetailViewController = NoteDetailViewController()
        noteDetailViewController.delegate = self
        noteDetailViewController.noteDataSource = noteDataSource
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
    func noteListView(didSeletedCell row: Int) {
        if let detailViewController = viewController(
            for: .secondary
        ) as? NoteDetailViewController {
            detailViewController.setupDetailView(index: row)
        }
    }
}

// MARK: - NoteDetailView Delegate

extension CloudNotesSplitViewController: NoteDetailViewDelegate {
    func textViewDidChange(noteInformation: NoteInformation) {
        
    }
}
