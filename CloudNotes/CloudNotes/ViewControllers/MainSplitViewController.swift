//
//  MainSplitViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit

class MainSplitVieWController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let memoListTableViewController = MemoListTableViewController()
        let memoDetailViewController = MemoDetailViewController()
        memoListTableViewController.delegate = memoDetailViewController
        let memoListNavigationController = UINavigationController(rootViewController: memoListTableViewController)
        let memoDetailNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        self.viewControllers = [memoListNavigationController, memoDetailNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
}

extension MainSplitVieWController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
