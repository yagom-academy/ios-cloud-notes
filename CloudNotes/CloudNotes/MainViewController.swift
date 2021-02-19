//
//  MainViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/18.
//

import UIKit

class MainViewController: UISplitViewController {
    private let masterViewController = ListViewController()
    private let detailViewController = ContentViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        masterViewController.delegate = detailViewController

        
        self.viewControllers = [UINavigationController(rootViewController: masterViewController), detailViewController]
    }
}

extension MainViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
