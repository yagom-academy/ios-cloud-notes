//
//  MainSplitViewController.swift
//  CloudNotes
//
//  Created by steven on 2021/05/31.
//

import UIKit

class MainSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationEmbeddedListTableViewController = UINavigationController(rootViewController: ListTableViewController())
        let navigationEmbeddedTextViewController = UINavigationController(rootViewController: TextViewController())
        self.viewControllers = [navigationEmbeddedListTableViewController, navigationEmbeddedTextViewController]
        self.preferredDisplayMode = .oneBesideSecondary
        self.delegate = self
    }

}

extension MainSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
