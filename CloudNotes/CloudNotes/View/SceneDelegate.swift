//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private let splitVC = SplitViewController()
  private let listVC = ListViewController()
  private let memoVC = MemoViewController()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    
    listVC.title = "메모"
    listVC.delegate = self
    
    splitVC.viewControllers = [
      UINavigationController(rootViewController: listVC),
      UINavigationController(rootViewController: memoVC)
    ]
    
    window?.rootViewController = splitVC
    window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }
}

extension SceneDelegate: ListViewControllerDelegate {
  func didTapMenuItem(at index: Int, model memoInfo: MemoInfo) {
    memoVC.viewModel.update(model: memoInfo)
    memoVC.updateUI()
    
    // FIXME: - 기기가 아이폰일 경우, 화면전환이 안되는 문제
    if UIDevice.current.userInterfaceIdiom == .phone {
      listVC.navigationController?.pushViewController(memoVC, animated: true)
    }
  }
}
