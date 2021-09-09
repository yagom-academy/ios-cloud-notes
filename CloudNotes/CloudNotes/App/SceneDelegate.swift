//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        setWindowAndCoreData(windowScene: windowScene)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    private func setWindowAndCoreData(windowScene: UIWindowScene) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let coreDataContainer = appDelegate.persistentContainer
        let splitViewController = SplitViewController(style: .doubleColumn)
        splitViewController.coreDataContainer = coreDataContainer

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
    }

}
