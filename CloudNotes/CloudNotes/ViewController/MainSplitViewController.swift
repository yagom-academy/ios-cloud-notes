import UIKit
import SwiftyDropbox

final class MainSplitViewController: UISplitViewController {
    private let listViewController = MemoListViewController()
    private let contentViewController = MemoContentViewController()
    private var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainSplitView()
        setupKeyboardNotification()
        hideKeyboardWhenTappedBackground()
        CoreDataManager.shared.memoListViewController = listViewController
        CoreDataManager.shared.memoContentViewController = contentViewController
        presentIndicatorView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DropboxManager.isAuthorized == false {
            DropboxManager().authorize(viewController: self)
            DropboxManager.isAuthorized = true
        }
    }
    
    func updateMemoContentsView(with memo: Memo) {
        contentViewController.selectedMemo = memo
        contentViewController.reload()
        showDetailViewController(contentViewController, sender: nil)
    }
    
    func reloadAll() {
        listViewController.reload()
        contentViewController.reload()
        indicatorView?.removeFromSuperview()
        indicatorView = nil
    }

    private func setupMainSplitView() {
        configureSplitView()
    }
    
    private func configureSplitView() {
        setViewController(listViewController, for: .primary)
        setViewController(contentViewController, for: .secondary)
    }
    
    private func presentIndicatorView() {
        let indicator = UIActivityIndicatorView()
        indicator.backgroundColor = .systemGray3
        indicator.style = .large
        indicatorView = indicator
        
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        indicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        indicator.startAnimating()
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
