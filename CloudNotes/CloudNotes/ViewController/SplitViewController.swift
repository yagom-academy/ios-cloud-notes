//
//  MainSplitViewController.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

class SplitViewController: UISplitViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.viewControllers = [
      UINavigationController(rootViewController: MemoListViewController()),
      UINavigationController(rootViewController: MemoDetailViewController())
    ]
    self.preferredDisplayMode = .oneBesideSecondary
  }
}

extension SplitViewController: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    return true
  }
}
