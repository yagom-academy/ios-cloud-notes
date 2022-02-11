import UIKit

final class MainSplitViewController: UISplitViewController {
    private let listViewController = MemoListViewController()
    private let contentViewController = MemoContentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainSplitView()
        setupKeyboardNotification()
    }
    
    func updateMemoContentsView(with memo: Memo) {
        contentViewController.updateTextView(with: memo)
        contentViewController.selectedMemo = memo
        showDetailViewController(contentViewController, sender: nil)
    }
    
    func reloadMemoList() {
        listViewController.loadMemos()
    }
     
    private func setupMainSplitView() {
        configureSplitView()
        configureNavigationBar()
    }
    
    private func configureSplitView() {
        setViewController(listViewController, for: .primary)
        setViewController(contentViewController, for: .secondary)
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = displayModeButtonItem
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
    
    private func hideKeyboard() {
        let tapEmptySpace = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapEmptySpace)
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
