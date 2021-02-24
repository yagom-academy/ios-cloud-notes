//
//  NoteSplitViewController.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/19.
//

import UIKit

class NoteSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let noteViewController = NoteViewController()
        let masterViewController = UINavigationController(rootViewController: noteViewController)
        self.viewControllers = [masterViewController]
        self.preferredPrimaryColumnWidthFraction = UIConstants.layout.noteSplitViewPreferredPrimaryColumnWidthFraction
        self.preferredDisplayMode = .oneBesideSecondary
    }
}
