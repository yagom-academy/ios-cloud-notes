//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/05.
//

import UIKit

class SplitViewController: UISplitViewController {
    private let detailVC = SecondaryViewController()
    private let primaryVC = PrimaryViewController()
    private let splitViewDelegate = SplitViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decideSpliveVCPreferences()
        self.delegate = splitViewDelegate
    }
}

extension SplitViewController {
    private func decideSpliveVCPreferences() {
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .displace
        self.setViewController(primaryVC, for: .primary)
        self.setViewController(detailVC, for: .secondary)
    }
}
