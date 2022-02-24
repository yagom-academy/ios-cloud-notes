import UIKit
import SwiftyDropbox

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
        CoreDataManager.shared.saveContextChange()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let oauthCompletion: DropboxOAuthCompletion = {
            if let authResult = $0 {
                switch authResult {
                case .success:
                    print("Success! User is logged into DropboxClientsManager.")
                    guard let window = self.window,
                        let splitViewController = window.rootViewController as? MainSplitViewController else {
                        return
                    }
                    DropboxManager().download {
                        splitViewController.reloadAll()
                    } errorHandler: { errorMessages in
                        print(errorMessages)
                    }
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

    func sceneWillResignActive(_ scene: UIScene) {
        DropboxManager().upload { errorMessages in
            print(errorMessages)
        }
    }
}

