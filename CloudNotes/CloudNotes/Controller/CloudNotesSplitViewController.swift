//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class CloudNotesSplitViewController: UISplitViewController {
    
    // MARK: - properties
    
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
        let persistantManager = PersistantManager()
        
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
    func textViewDidChange(noteInformation: NoteInformation) {
        if let listViewController = viewController(
            for: .primary
        ) as? NoteListViewController {
            listViewController.updateListView(index: currentIndex, noteInformation: noteInformation)
        }
    }
}
