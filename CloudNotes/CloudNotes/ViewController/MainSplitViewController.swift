import UIKit
import SwiftyDropbox

final class MainSplitViewController: UISplitViewController {
    private let listViewController = MemoListViewController()
    private let contentViewController = MemoContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainSplitView()
        setupKeyboardNotification()
        hideKeyboardWhenTappedBackground()
        CoreDataManager.shared.memoListViewController = listViewController
        CoreDataManager.shared.memoContentViewController = contentViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if DropboxManager.isAuthorized == false {
            beginAuthorizationFlow()
            DropboxManager.isAuthorized = true
        }
    }
    
    func beginAuthorizationFlow() {
        let scopes = [
            "account_info.read",
            "account_info.write",
            "files.content.read",
            "files.content.write",
            "files.metadata.read",
            "files.metadata.write"
        ]
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: scopes, includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: self,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
    }
    
    func updateMemoContentsView(with memo: Memo) {
        contentViewController.selectedMemo = memo
        contentViewController.reload()
        showDetailViewController(contentViewController, sender: nil)
    }
    
    func reloadAll() {
        listViewController.reload()
        contentViewController.reload()
    }

    private func setupMainSplitView() {
        configureSplitView()
    }
    
    private func configureSplitView() {
        setViewController(listViewController, for: .primary)
        setViewController(contentViewController, for: .secondary)
    }
}

// MARK: - Keyboard Notification Setup Method
extension MainSplitViewController {
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let window = view.window else { return }
        
        let keyboardRect = keyboardFrame.cgRectValue
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        self.view.frame = window.frame.inset(by: inset)
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        guard let window = view.window else { return }
        view.frame = window.frame
    }

    private func hideKeyboardWhenTappedBackground() {
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapEvent.cancelsTouchesInView = false
        view.addGestureRecognizer(tapEvent)
    }
    
    @objc func dismissKeyboard() {
        contentViewController.view.endEditing(true)
    }
}
