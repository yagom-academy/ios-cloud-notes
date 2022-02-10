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
    
    func updateTextView(with memoDetailInfo: MemoDetailInfo) {
        self.memoDetailTextView.text = memoDetailInfo.text
    }
    
    func updateIndex(with index: Int) {
        currentIndex = index
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
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        let memo = createMemoData(with: textView.text)
        splitVC.updateMemoList(at: currentIndex, with: memo)
    }
    
    private func createMemoData(with text: String) -> Memo {
        let data = text.split(separator: Constant.lineBreak, maxSplits: 1)
        let lastModified = Date().timeIntervalSince1970
        let title = data[safe: 0]?.description ?? Constant.newMemo
        let body = data[safe: 1]?.trimmingCharacters(in: Constant.trimmingStringSet) ?? Constant.emptyBody
        return Memo(title: title, body: body, lastModified: lastModified)
    }
}
