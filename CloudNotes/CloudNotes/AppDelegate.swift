//
//  CloudNotes - AppDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            return true
        }
        window = UIWindow()
        window?.rootViewController = SplitViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    @objc func receiveNotification(_ notification: Notification) {
        let alert = UIAlertController(title: "에러가 발생했습니다.", message: "앱을 종료했다가 다시 켜주세요!", preferredStyle: .alert)
        
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                return
            }
            sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        } else {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack
    @available(iOS 13.0, *)
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: Notification.Name("loadPersistentStoresError"), object: nil)
            }
        })
        return container
    }()
}

