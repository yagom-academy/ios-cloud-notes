//
//  NotesSplitViewController.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import UIKit

class NotesSplitViewController: UISplitViewController {
    private var primaryTableViewController = PrimaryTableViewController(style: .insetGrouped)
    private var secondaryViewController = SecondaryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplitViewController()
    }
    
    private func configureSplitViewController() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        setViewController(primaryTableViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
    }
    
    func showSecondaryView(with memo: Memo) {
        secondaryViewController.updateMemo(text: memo.body)
        show(.secondary)
    }
}
