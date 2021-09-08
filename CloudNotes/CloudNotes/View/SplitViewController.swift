//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/01.
//

import UIKit

class SplitViewController: UISplitViewController, RootViewControllerable {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let master = UINavigationController()
        let detail = UINavigationController()
        master.viewControllers = [MemoListViewController()]
        detail.viewControllers = [MemoDetailViewController()]
        self.viewControllers = [master, detail]
        preferredDisplayMode = .oneBesideSecondary
        self.view.backgroundColor = .white
        self.delegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
            return true
        }
}
