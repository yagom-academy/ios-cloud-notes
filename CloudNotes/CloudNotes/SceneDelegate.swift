//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SwiftyDropbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let memoStorage = (UIApplication.shared.delegate as! AppDelegate).memoStorage
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let memoSplitViewController = self.window?.rootViewController as! MemoSplitViewController
        let memoTableViewController = memoSplitViewController.viewController(for: .primary) as! MemoTableViewController
        let oauthCompletion: DropboxOAuthCompletion = {
            if let authResult = $0 {
                switch authResult {
                case .success:
                    UserDefaults.standard.set(true, forKey: UserDefaultsKey.dropboxConnected)
                    self.memoStorage.downloadDropboxData { isSuccess in
                        if isSuccess {
                            DispatchQueue.main.async {
                                memoSplitViewController.presentConnectResultAlert(type: .connectSuccess)
                                memoTableViewController.updateTableView()
                            }
                        }
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
        window?.rootViewController = MemoSplitViewController(style: .doubleColumn, memoStorage: memoStorage)
        window?.makeKeyAndVisible()
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.dropboxConnected) {
            memoStorage.downloadDropboxData()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        memoStorage.uploadAll()
    }
}

