import UIKit
import SwiftyDropbox

import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let persistentDataManager = PersistentDataManager()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let mainSplitViewController = configureSplitView()
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainSplitViewController
        window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let oauthCompletion: DropboxOAuthCompletion = {
              if let authResult = $0 {
                  switch authResult {
                  case .success:
                      print("Success! User is logged into DropboxClientsManager.")
                  case .cancel:
                      print("Authorization flow was manually canceled by user!")
                  case .error(_, let description):
                      print("Error: \(String(describing: description))")
                  }
              }
            }

            for context in URLContexts {
                // stop iterating after the first handle-able url
                if DropboxClientsManager.handleRedirectURL(context.url, completion: oauthCompletion) { break }
            }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        persistentDataManager.saveContext()
    }
    
}

extension SceneDelegate {
    
    private func configureSplitView() -> UISplitViewController {
        let model = NoteModel(persistentDataManager: persistentDataManager)
        let viewModel = NoteViewModel(model: model)
        
        let primaryViewController = NoteTableViewController(viewModel: viewModel)
        let secondaryViewController = NoteDetailViewController(viewModel: viewModel)
        let splitViewController = UISplitViewController(style: .doubleColumn)
        
        primaryViewController.delegate = secondaryViewController
        splitViewController.view.backgroundColor = .systemBackground
        splitViewController.setViewController(primaryViewController, for: .primary)
        splitViewController.setViewController(secondaryViewController, for: .secondary)
        
        return splitViewController
    }
    
}
