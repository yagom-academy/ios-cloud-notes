//
//  NotesSplitViewController.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import UIKit

class NotesSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplitViewController()
    }
    
    private func configureSplitViewController() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        setViewController(PrimaryTableViewController(), for: .primary)
        setViewController(SecondaryViewController(), for: .secondary)
    }
}
