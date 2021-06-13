//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import OSLog

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var noteCoreDataStack: NoteCoreDataStack = .shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            os_log(.fault, log: .ui, OSLog.objectCFormatSpecifier, UIError.typeCastingFailed(subject: "scene", location: #function).localizedDescription)
            return
        }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let splitViewController = NoteSplitViewController(style: .doubleColumn)
        
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        noteCoreDataStack.saveContext()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        noteCoreDataStack.saveContext()
    }
}
