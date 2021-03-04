//
//  MainSplitViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit

class MainSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let memoListTableViewController = MemoListTableViewController()
        let memoDetailViewController = MemoDetailViewController()
        
        memoDetailViewController.delegate = memoListTableViewController
        let memoDetailNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        
        memoListTableViewController.delegate = memoDetailViewController
        let memoListNavigationController = UINavigationController(rootViewController: memoListTableViewController)
        
        self.viewControllers = [memoListNavigationController, memoDetailNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
}

extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
