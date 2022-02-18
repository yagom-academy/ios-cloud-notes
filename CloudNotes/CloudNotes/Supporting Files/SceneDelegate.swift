import UIKit

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

    func sceneDidEnterBackground(_ scene: UIScene) {
        persistentDataManager.saveContext()
    }
    
}

extension SceneDelegate {
    
    private func configureSplitView() -> UISplitViewController {
        let model = NoteModel(persistentDataManager: persistentDataManager)
        let viewModel = NoteViewModel(model: model)
        
        let primaryViewController = NoteListTableViewController(model: viewModel)
        let secondaryViewController = NoteDetailViewController(model: viewModel)
        let splitViewController = UISplitViewController(style: .doubleColumn)

        primaryViewController.delegate = secondaryViewController
        splitViewController.view.backgroundColor = .systemBackground
        splitViewController.setViewController(primaryViewController, for: .primary)
        splitViewController.setViewController(secondaryViewController, for: .secondary)

        return splitViewController
    }
    
}
