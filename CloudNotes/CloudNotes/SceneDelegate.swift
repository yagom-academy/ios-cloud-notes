//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SwiftyDropbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windoewScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: windoewScene)
        let splitVC = SplitViewController(style: .doubleColumn)
        window?.rootViewController = splitVC
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // MARK: - Dropbox Redirection
        let oauthCompletion: DropboxOAuthCompletion = {
             if let authResult = $0 {
                 switch authResult {
                 case .success:
                     print("Success! User is logged into DropboxClientsManager.")
                     let splitVC = self.window?.rootViewController as? SplitViewController
                     let primaryVC = splitVC?.viewController(for: .primary) as? UITableViewController
                     DropBoxManager().download(primaryVC)
                 case .cancel:
                     print("Authorization flow was manually canceled by user!")
                 case .error(_, let description):
                     print("Error: \(String(describing: description))")
                 }
             }
           }

           for context in URLContexts {
               if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
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
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

