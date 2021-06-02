//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let mainViewController = ListViewController()
    let navigationController = UINavigationController(rootViewController: mainViewController)
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }
}
