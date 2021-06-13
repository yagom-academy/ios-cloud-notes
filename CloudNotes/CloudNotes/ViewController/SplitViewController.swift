//
//  CloudNotes - SplitViewController.swift
//  Created by 배은서.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class SplitViewController: UISplitViewController {
    let noteListViewController = NoteListViewController()
    let noteDetailViewController = NoteDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        noteListViewController.noteDelegate = self
        self.preferredDisplayMode = .oneBesideSecondary
        
        self.viewControllers = [
            UINavigationController(rootViewController: noteListViewController),
            UINavigationController(rootViewController: noteDetailViewController)
        ]
    }
}

extension SplitViewController: NoteDelegate {
    func showDetailNote(_ listViewController: NoteListViewController, data: NoteViewModel) {
        noteDetailViewController.noteViewModel = NoteTextViewModel(Observable(data))
        
        let noteDetailNavigationController = UINavigationController(rootViewController: noteDetailViewController)
        self.showDetailViewController(noteDetailNavigationController, sender: self)
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
