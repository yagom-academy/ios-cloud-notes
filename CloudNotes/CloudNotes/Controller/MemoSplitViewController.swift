//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import UIKit

class MemoSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setSplitView()
    }
    
    func setSplitView() {
        let memoListViewController = MemoListViewController()
        let detailViewController = DetailViewController()
        memoListViewController.title = "메모"
        memoListViewController.delegate = detailViewController
        self.preferredDisplayMode = .oneBesideSecondary
        self.setViewController(memoListViewController, for: .primary)
        self.setViewController(detailViewController, for: .secondary)
        self.preferredSplitBehavior = .tile
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
    
}
