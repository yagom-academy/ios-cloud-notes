//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/02/18.
//

import UIKit

final class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        let listViewController = ListViewController()
        let detailViewController = DetailViewController()
        let leftNavigationController = UINavigationController(rootViewController: listViewController)
        let rightNavigationController = UINavigationController(rootViewController: detailViewController)
        self.viewControllers = [leftNavigationController, rightNavigationController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
        
        listViewController.delegate = detailViewController
        detailViewController.delegate = listViewController
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
