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
        self.viewControllers = [masterViewController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }

}
