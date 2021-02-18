//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/02/18.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let listViewController = ListViewController()
        let detailViewController = DetailViewController()
        let leftNavigationController = UINavigationController(rootViewController: listViewController)
        let rightNavigationController = UINavigationController(rootViewController: detailViewController)
        self.viewControllers = [leftNavigationController, rightNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
        
        listViewController.delegate = detailViewController
    }
}
