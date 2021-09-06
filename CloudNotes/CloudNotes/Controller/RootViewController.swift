//
//  ViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/06.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let splitVC = UISplitViewController(style: .doubleColumn)
        self.addChild(splitVC)
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.bounds
        splitVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        splitVC.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        splitVC.preferredSplitBehavior = .tile
        splitVC.didMove(toParent: self)
        
        let memoListVC = MemoTableViewController(isCompact: false)
        splitVC.setViewController(memoListVC, for: .primary)
        
        let memoDetailVC = MemoDetailViewController()
        let memoDetailNavgation = UINavigationController(rootViewController: memoDetailVC)
        splitVC.setViewController(memoDetailNavgation, for: .secondary)
        
        let memoListCompactVC = MemoTableViewController(isCompact: true)
        let memoListCompactNavigation = UINavigationController(rootViewController: memoListCompactVC)
        splitVC.setViewController(memoListCompactNavigation, for: .compact)
    }
}
