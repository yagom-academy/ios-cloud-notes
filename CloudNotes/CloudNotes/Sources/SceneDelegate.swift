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
        let primaryViewController = MemoListViewController()
        let secondaryViewController = MemoViewController()

        memoSplitViewController.setViewController(primaryViewController, for: .primary)
        memoSplitViewController.setViewController(secondaryViewController, for: .secondary)
        memoSplitViewController.preferredDisplayMode = .oneBesideSecondary
        memoSplitViewController.presentsWithGesture = false
        memoSplitViewController.delegate = secondaryViewController

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
