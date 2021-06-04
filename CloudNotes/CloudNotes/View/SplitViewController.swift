//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/04.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
  }
  
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto primaryViewController: UIViewController) -> Bool {
    return true
  }
}
