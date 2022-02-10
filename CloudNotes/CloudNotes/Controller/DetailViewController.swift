import UIKit

class DetailViewController: UIViewController {
  private let textView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    return textView
  }()
  private var memoComponents: (title: String, body: String) {
    let memoComponents = textView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
    let title = memoComponents[safe: 0] ?? ""
    let body = memoComponents[safe: 1] ?? ""
    return (title, body)
  }
  
  private var memo: Memo?
  weak var delegate: DetailViewControllerDelegate?
  
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
  
  private func refreshUI() {
    let title = memo?.title ?? ""
    let body = memo?.body ?? ""
    textView.text = title.isEmpty && body.isEmpty ? "" : title + "\n" + body
  }
  
  private func setNavigationBar() {
    let buttonImage = UIImage(systemName: "ellipsis.circle")
    let ellipsisCircleButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: nil)
    navigationItem.rightBarButtonItem = ellipsisCircleButton
  }
}

// MARK: - MemoListViewControllerDelegate

extension DetailViewController: MemoListViewControllerDelegate {
  func load(memo: Memo?) {
    self.memo = memo
    refreshUI()
  }
}

// MARK: - UITextViewDelegate

extension DetailViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    memo?.title = memoComponents.title
    memo?.body = memoComponents.body
    memo?.lastModified = Date()
    guard let memo = memo else { return }
    delegate?.update(memo)
  }
}
