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

        let memoSplitViewController = UISplitViewController(style: .doubleColumn)
        memoSplitViewController.setViewController(MemoListViewController(), for: .primary)
        memoSplitViewController.setViewController(MemoViewController(), for: .secondary)
        memoSplitViewController.preferredDisplayMode = .oneBesideSecondary
        memoSplitViewController.presentsWithGesture = false

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = memoSplitViewController
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()

        self.window = window
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
