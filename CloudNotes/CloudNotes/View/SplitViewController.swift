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
    
    // FIXME: - 기기가 아이폰일 경우, 화면전환이 안되는 문제
    if UIDevice.current.userInterfaceIdiom == .phone
        && UITraitCollection.current.horizontalSizeClass == .compact {
      listViewController.navigationController?.pushViewController(memoViewController, animated: true)
    }
  }
}
