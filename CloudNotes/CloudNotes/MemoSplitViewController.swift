//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

class MemoSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let memoTableViewController = MemoTableViewController()
        let masterViewController = UINavigationController(rootViewController: memoTableViewController)
        let detailViewController = MemoViewController()
        memoTableViewController.memoViewControllerDelegate = detailViewController
        self.viewControllers = [masterViewController, detailViewController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }

}
