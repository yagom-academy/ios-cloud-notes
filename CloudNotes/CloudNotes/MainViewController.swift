//
//  MainViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/18.
//

import UIKit

class MainViewController: UISplitViewController, UISplitViewControllerDelegate {
    let masterViewController = ListViewController()
    let detailViewController = ContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [UINavigationController(rootViewController: masterViewController)]
        self.preferredPrimaryColumnWidthFraction = 0.4
        self.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        self.viewControllers = [UINavigationController(rootViewController: masterViewController)]
    }
}
