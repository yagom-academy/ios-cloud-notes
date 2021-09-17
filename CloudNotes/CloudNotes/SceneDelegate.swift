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
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        let splitView = SplitViewController()
        let menu = MenuViewController()
        let detail = DetailViewController()
        
        splitView.preferredDisplayMode = .oneBesideSecondary
        splitView.viewControllers = setup(menu: menu, detail: detail)
        splitView.menu = menu
        splitView.detail = detail
        menu.splitView = splitView
        detail.splitView = splitView
        
        window?.rootViewController = splitView
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    private func setup(menu: UIViewController, detail: UIViewController) -> [UINavigationController] {
        let rootNavi = UINavigationController(rootViewController: menu)
        let detailNavi = UINavigationController(rootViewController: detail)
        return [rootNavi, detailNavi]
    }
}

