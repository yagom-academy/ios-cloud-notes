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
        decideSpliveVCPreferences()
        self.delegate = splitViewDelegate
    }
}
// 뷰컨이 두개 -  width가 레귤러, 

extension SplitViewController {
    private func decideSpliveVCPreferences() {
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .displace
        setViewController(primaryVC, for: .primary)
        setViewController(detailVC, for: .secondary)
    }
}
