//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/02.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplitViewController()
    }
    
    private func configureSplitViewController() {
        let memoDetailViewController = MemoDetailViewController()
        let memoListViewController = MemoListViewController(detailViewDelegate: memoDetailViewController as MemoDetailViewDelegate)
        let memoListNavigationController = UINavigationController(rootViewController: memoListViewController)
        let memoDetailNavigationController = UINavigationController(rootViewController: memoDetailViewController)
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        self.viewControllers = [memoListNavigationController, memoDetailNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
