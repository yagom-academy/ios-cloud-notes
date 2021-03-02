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
        viewControllers = [UINavigationController(rootViewController: masterViewController)]
        preferredPrimaryColumnWidthFraction = 0.4
        preferredDisplayMode = .oneBesideSecondary
    }
}
