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

        let splitViewController = UISplitViewController(style: .doubleColumn)
        self.addChild(splitViewController)
        self.view.addSubview(splitViewController.view)
        splitViewController.view.frame = self.view.bounds
        splitViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        splitViewController.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        splitViewController.preferredSplitBehavior = .tile
        splitViewController.presentsWithGesture = false
        splitViewController.didMove(toParent: self)
        
        let memoListViewController = MemoTableViewController(isCompact: false)
        splitViewController.setViewController(memoListViewController, for: .primary)
        
        let memoDetailViewController = MemoDetailViewController()
        let memoDetailNavgation = UINavigationController(rootViewController: memoDetailViewController)
        splitViewController.setViewController(memoDetailNavgation, for: .secondary)
        
        let memoListCompactViewController = MemoTableViewController(isCompact: true)
        let memoListCompactNavigation = UINavigationController(rootViewController: memoListCompactViewController)
        splitViewController.setViewController(memoListCompactNavigation, for: .compact)
    }
}
