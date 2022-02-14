import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let noteModelManager: NoteModel = NoteModelManager()
    private lazy var primaryViewController = NoteListTableViewController(model: noteModelManager)
    private lazy var secondaryViewController = NoteDetailViewController()
    private lazy var rootViewController: UISplitViewController = {
        let splitViewController = UISplitViewController(style: .doubleColumn)
        splitViewController.view.backgroundColor = .systemBackground
        return splitViewController
    }()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        configureRootView()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    private func configureRootView() {
        primaryViewController.delegate = secondaryViewController
        rootViewController.setViewController(primaryViewController, for: .primary)
        rootViewController.setViewController(secondaryViewController, for: .secondary)
    }
    
}
