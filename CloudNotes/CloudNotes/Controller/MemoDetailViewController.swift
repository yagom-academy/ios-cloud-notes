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
    
    func updateData(with index: Int) {
        currentIndex = index
        memoDetailTextView.text = MemoDataManager.shared.memoList[safe: currentIndex]?.body
    }
}

// MARK: - 초기 ViewController 설정
extension MemoDetailViewController {
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

// MARK: - TextViewDelegate
extension MemoDetailViewController: UITextViewDelegate {
    enum Constant {
        static let lineBreak: Character = "\n"
        static let trimmingStringSet: CharacterSet = ["\n", " "]
        static let newMemo = "새로운 메모"
        static let emptyBody = "추가 텍스트 없음"
        static let title = "title"
        static let body = "body"
        static let lastModified = "lastModified"
        static let memo = "Memo"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        updateMemoData(with: textView.text)
        splitVC.updateMemoList(at: currentIndex)
    }

    private func updateMemoData(with text: String) {
        let data = text.split(separator: Constant.lineBreak, maxSplits: 1)
        let lastModified = Date().timeIntervalSince1970
        let title = data[safe: 0]?.description
        let body = data[safe: 1]?.trimmingCharacters(in: Constant.trimmingStringSet)
        guard let id = MemoDataManager.shared.memoList[safe: currentIndex]?.id else {
            return
        }
        MemoDataManager.shared.updateMemo(id: id, title: title, body: body, lastModified: lastModified)
    }
}
