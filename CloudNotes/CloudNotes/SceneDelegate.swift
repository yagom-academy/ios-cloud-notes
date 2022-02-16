import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        let mainSplitViewController = MainSplitViewController(style: .doubleColumn)
        
        mainSplitViewController.preferredDisplayMode = .oneBesideSecondary
        mainSplitViewController.preferredSplitBehavior = .tile
        window?.rootViewController = mainSplitViewController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.saveContext()
    }
}

