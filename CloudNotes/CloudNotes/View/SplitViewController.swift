//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/04.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  private let listVC = ListViewController()
  private let memoVC = MemoViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setViewControllers()
  }
  
  private func setViewControllers() {
    delegate = self
    
    listVC.title = "메모"
    listVC.delegate = self
    
    viewControllers = [
      UINavigationController(rootViewController: listVC),
      UINavigationController(rootViewController: memoVC)
    ]
  }
  
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto primaryViewController: UIViewController) -> Bool {
    return true
  }
}

extension SplitViewController: ListViewControllerDelegate {
  func didTapMenuItem(at index: Int, model memoInfo: MemoInfo) {
    memoVC.viewModel.update(model: memoInfo)
    memoVC.updateUI()
    
    // FIXME: - 기기가 아이폰일 경우, 화면전환이 안되는 문제
    if UIDevice.current.userInterfaceIdiom == .phone {
      listVC.navigationController?.pushViewController(memoVC, animated: true)
    }
  }
}
