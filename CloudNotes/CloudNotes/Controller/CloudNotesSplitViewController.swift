//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class CloudNotesSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        preferredDisplayMode = .oneBesideSecondary
        view.backgroundColor = .white
        let noteDataSource = CloudNotesDataSource()
        let noteListViewController = NoteListViewController()
        noteListViewController.delegate = self
        noteListViewController.noteDataSource = noteDataSource
        let noteDetailViewController = NoteDetailViewController()
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

extension CloudNotesSplitViewController: NoteListViewDelegate {
    func noteListView(didSeletedCell row: Int) {
        if let detailViewController = viewController(
            for: .secondary
        ) as? NoteDetailViewController {
            detailViewController.setupDetailView(index: row)
        }
    }
}
