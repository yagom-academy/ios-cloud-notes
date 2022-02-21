import UIKit

final class DetailViewController: UIViewController {
  weak var delegate: MemoStorable?
  private let textView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.keyboardDismissMode = .interactive
    return textView
  }()
  private let ellipsisCircleButton: UIBarButtonItem = {
    let buttonImage = UIImage(systemName: "ellipsis.circle")
    return UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(showMoreButtonTapped))
  }()
  private var keyboardShowNotification: NSObjectProtocol?
  private var keyboardHideNotification: NSObjectProtocol?

  deinit {
    removeObservers()
  }
  
  private var currentMemo: (title: String, body: String) {
    let memoComponents = textView.text.split(
      separator: "\n",
      maxSplits: 1,
      omittingEmptySubsequences: false
    ).map(String.init)
    let title = memoComponents[safe: 0] ?? ""
    let body = memoComponents[safe: 1] ?? ""
    return (title, body)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: view.topAnchor),
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    textView.delegate = self
    
    setNavigationBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    addObservers()
  }

  private func addObservers() {
    if keyboardShowNotification == nil {
      let bottomInset = view.safeAreaInsets.bottom
      let addSafeAreaInset: (Notification) -> Void = { [weak self] notification in
        guard
          let self = self,
          let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
          return
        }
        self.additionalSafeAreaInsets.bottom = keyboardFrame.height - bottomInset
      }
      
      keyboardShowNotification = NotificationCenter.default.addObserver(
        forName: UIResponder.keyboardWillShowNotification,
        object: nil,
        queue: nil,
        using: addSafeAreaInset
      )
    }
    if keyboardHideNotification == nil {
      let removeSafeAreaInset: (Notification) -> Void = { [weak self] _ in
        self?.additionalSafeAreaInsets.bottom = 0
      }
      
      keyboardHideNotification = NotificationCenter.default.addObserver(
        forName: UIResponder.keyboardWillHideNotification,
        object: nil,
        queue: nil,
        using: removeSafeAreaInset
      )
    }
  }

  private func removeObservers() {
    if let keyboardShowNotification = keyboardShowNotification {
      NotificationCenter.default.removeObserver(keyboardShowNotification)
      self.keyboardShowNotification = nil
    }
    if let keyboardHideNotification = keyboardHideNotification {
      NotificationCenter.default.removeObserver(keyboardHideNotification)
      self.keyboardHideNotification = nil
    }
  }
  
  private func setNavigationBar() {
    navigationItem.rightBarButtonItem = ellipsisCircleButton
  }
  @objc private func showMoreButtonTapped(_ sender: UIBarButtonItem) {
    let textToShare = textView.text
    let delete = DeleteActivity()
    delete.delegate = delegate as? MemoActivityDelegate
    let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: [delete])
    activityViewController.popoverPresentationController?.barButtonItem = sender
    present(activityViewController, animated: true)
  }
}

// MARK: - MemoDisplayable

extension DetailViewController: MemoDisplayable {
  func showMemo(title: String?, body: String?) {
    let title = title ?? ""
    let body = body ?? ""
    textView.text = title.isEmpty && body.isEmpty ? "" : title + "\n" + body
    textView.endEditing(true)
    let topOffset = CGPoint(x: 0, y: 0 - view.safeAreaInsets.top)
    textView.setContentOffset(topOffset, animated: false)
  }
  
  func set(editable: Bool, needClear: Bool) {
    textView.isEditable = editable
    ellipsisCircleButton.isEnabled = editable
    if needClear {
      textView.text = ""
    }
  }
}

// MARK: - UITextViewDelegate

extension DetailViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    let newMemo = currentMemo
    delegate?.updateMemo(title: newMemo.title, body: newMemo.body)
  }
}

extension DetailViewController {
  class DeleteActivity: UIActivity {
    weak var delegate: MemoActivityDelegate?

    override var activityTitle: String? {
      return "Delete"
    }
    override var activityImage: UIImage? {
      return UIImage(systemName: "trash")
    }
    override class var activityCategory: UIActivity.Category {
      return UIActivity.Category.action
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
      return true
    }
    override func perform() {
      delegate?.removeCurrentMemo()
      activityDidFinish(true)
    }
  }
}

protocol MemoActivityDelegate: AnyObject {
  func removeCurrentMemo()
}
