//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/04.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  private let listViewController = ListViewController()
  private let memoViewController = MemoViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setViewControllers()
  }
  
  private func setViewControllers() {
    delegate = self
    preferredDisplayMode = .oneBesideSecondary
    
    listViewController.title = "메모"
    listViewController.delegate = self
    
    viewControllers = [
      UINavigationController(rootViewController: listViewController),
      UINavigationController(rootViewController: memoViewController)
    ]
  }
  
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto primaryViewController: UIViewController) -> Bool {
    return true
  }
}

extension SplitViewController: ListViewControllerDelegate {
  func didTapMenuItem(model memoInfo: MemoInfo) {
    memoViewController.viewModel.update(model: memoInfo)
    memoViewController.updateUI()
    
    showDetailViewController(memoViewController, sender: nil)
  }
}
