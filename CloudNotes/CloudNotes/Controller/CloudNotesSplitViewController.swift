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
        
        let noteListViewController = NoteListViewController()
        let noteDetailViewController = NoteDetailViewController()
        setViewController(noteListViewController, for: .primary)
        setViewController(noteDetailViewController, for: .secondary)
    }
}
