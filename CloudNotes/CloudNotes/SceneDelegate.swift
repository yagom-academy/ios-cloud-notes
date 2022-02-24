//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SwiftyDropbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let memoStorage = (UIApplication.shared.delegate as! AppDelegate).memoStorage
    private lazy var memoSplitViewController = window?.rootViewController as! MemoSplitViewController
    private lazy var memoTableViewController = memoSplitViewController.viewController(for: .primary) as! MemoTableViewController
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let oauthCompletion: DropboxOAuthCompletion = {
            if let authResult = $0 {
                switch authResult {
                case .success:
                    UserDefaults.standard.set(true, forKey: UserDefaultsKey.dropboxConnected)
                    self.memoStorage.downloadDropboxData { isSuccess in
                        if isSuccess {
                            DispatchQueue.main.async {
                                self.memoSplitViewController.presentConnectResultAlert(type: .connectSuccess)
                                self.memoTableViewController.updateTableView()
                            }
                        }
                    }
                case .cancel:
                    self.memoSplitViewController.presentConnectResultAlert(type: .connectFailure)
                case .error(_, _):
                    self.memoSplitViewController.presentConnectResultAlert(type: .connectFailure)
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
            memoStorage.downloadDropboxData { isSuccess in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.memoTableViewController.updateTableView()
                    }
                }
            }
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        memoStorage.uploadAll()
    }
}

