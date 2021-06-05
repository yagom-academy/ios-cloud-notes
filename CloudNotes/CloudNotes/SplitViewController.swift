//
//  CloudNotes - SplitViewController.swift
//  Created by Hailey.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class SplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .oneBesideSecondary
        NoteListViewController.noteDelegate = self
        
        self.viewControllers = [
            UINavigationController(rootViewController: NoteListViewController()),
            UINavigationController(rootViewController: NoteDetailViewController())
        ]
    }
}

extension SplitViewController: NoteDelegate {
    func showDetailNote(data: NoteData) {
        let noteDetailNC = UINavigationController(rootViewController: NoteDetailViewController())
        (noteDetailNC.viewControllers.last as? NoteDetailViewController)?.configureTextView(data)
        self.showDetailViewController(noteDetailNC, sender: self)
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
      }
}
