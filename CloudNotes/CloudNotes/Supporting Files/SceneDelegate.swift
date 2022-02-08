import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windewScene = (scene as? UIWindowScene) else {
            return
        }
        let mainViewController = UISplitViewController(style: .doubleColumn)
        let primaryViewController = NoteListTableViewController()
        let secondaryViewController = NoteDetailViewController()
        
        mainViewController.setViewController(primaryViewController, for: .primary)
        mainViewController.setViewController(secondaryViewController, for: .secondary)
        
        window = UIWindow(windowScene: windewScene)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
}
