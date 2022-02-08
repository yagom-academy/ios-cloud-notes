import UIKit

class MemoDetailViewController: UIViewController {
    private var currentIndex: Int = 0
    private let memoDetailTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigationItem()
        setUpTextView()
        setUpNotification()
        memoDetailTextView.delegate = self
    }
    
    func setUpData(with memoDetailInfo: MemoDetailInfo) {
        self.memoDetailTextView.text = memoDetailInfo.text
    }
    
    func updateIndex(with index: Int) {
        currentIndex = index
    }
    
    private func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    private func setUpTextView() {
        view.addSubview(memoDetailTextView)
        NSLayoutConstraint.activate([
            memoDetailTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoDetailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            memoDetailTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoDetailTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = memoDetailTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        memoDetailTextView.contentInset = contentInset
        memoDetailTextView.scrollIndicatorInsets = memoDetailTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        memoDetailTextView.contentInset = UIEdgeInsets.zero
        memoDetailTextView.scrollIndicatorInsets = memoDetailTextView.contentInset
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        let memo = createMemoData(with: textView.text)
        splitVC.updateMemoList(at: currentIndex, with: memo)
    }
    
    private func createMemoData(with text: String) -> Memo {
        let data = text.components(separatedBy: "\n\n")
        let title = data[0]
        let body = data[1]
        let lastModified = Date().timeIntervalSince1970
        return Memo(title: title, body: body, lastModified: lastModified)
    }
}
