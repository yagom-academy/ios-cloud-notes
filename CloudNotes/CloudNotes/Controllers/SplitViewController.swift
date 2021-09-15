//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/08.
//

import UIKit

class SplitViewController: UISplitViewController {
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

// MARK: - Protocol Conform
extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        true
    }
}
