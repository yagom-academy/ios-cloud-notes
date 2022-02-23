//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SwiftyDropbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let memoSplitViewController = self.window?.rootViewController as! MemoSplitViewController
        let oauthCompletion: DropboxOAuthCompletion = {
            if let authResult = $0 {
                switch authResult {
                case .success:
                    self.coreDataManager.synchronizeCoreDataToDropbox()
                    UserDefaults.standard.set(true, forKey: UserDefaultsKey.dropboxConnected)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        memoSplitViewController.presentConnectResultAlert(type: .connectSuccess)
                    }
                case .cancel:
                    memoSplitViewController.presentConnectResultAlert(type: .connectFailure)
                case .error(_, _):
                    memoSplitViewController.presentConnectResultAlert(type: .connectFailure)
                }
            }
        }
        
        for context in URLContexts {
            if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) {
                break
            }
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MemoSplitViewController(style: .doubleColumn, coreDataManager: coreDataManager)
        window?.makeKeyAndVisible()
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.dropboxConnected) {
            coreDataManager.synchronizeCoreDataToDropbox()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        coreDataManager.uploadAll()
    }
}

