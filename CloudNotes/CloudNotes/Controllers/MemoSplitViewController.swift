//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

class MemoSplitViewController: UISplitViewController {
    let memoTableViewController = MemoTableViewController()
    let memoViewController = MemoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let masterViewController = UINavigationController(rootViewController: memoTableViewController)
        self.viewControllers = [masterViewController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewControllers.append(memoViewController)
    }
}
