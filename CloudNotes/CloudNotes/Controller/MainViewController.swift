//
//  MainViewController.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/19.
//

import UIKit

class MainViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController()
        let detailViewController = DetailViewController()
        let listViewNavigationController = UINavigationController(rootViewController: listViewController)
        let detailViewNavigationController = UINavigationController(rootViewController: detailViewController)

        self.viewControllers = [listViewNavigationController, detailViewNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
}
