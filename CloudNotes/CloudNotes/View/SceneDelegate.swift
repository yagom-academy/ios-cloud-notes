//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private let splitVC = SplitViewController()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = splitVC
    window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }
}
