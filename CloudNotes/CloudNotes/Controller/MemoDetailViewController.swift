import UIKit

class MemoDetailViewController: UIViewController {
    enum Constant {
        static let lineBreak: Character = "\n"
        static let navigationBarIconName = "ellipsis.circle"
        static let headerAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(for: .title1, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        static let bodyAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: UIColor.label
        ]
    }
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
    
    func clearTextView() {
        memoDetailTextView.text = nil
    }
}

// MARK: - 초기 ViewController 설정
extension MemoDetailViewController {
    private func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constant.navigationBarIconName),
            style: .plain,
            target: self,
            action: #selector(moreViewbuttonTapped(_:))
        )
    }
    @objc func moreViewbuttonTapped(_ sender: UIBarButtonItem) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        print(sender)
        self.showMemoActionSheet(shareHandler: { _ in
            self.showActivityViewController(view: splitVC, data: MemoDataManager.shared.memoList[self.currentIndex].body ?? "")
        }, deleteHandler: {_ in
            self.showAlert(message: "정말 삭제하시겠습니까?", actionTitle: "OK") { _ in
                splitVC.deleteTableViewCell(indexPath: IndexPath(row: self.currentIndex, section: .zero))
            }
        }, sender: sender)
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
    func textViewDidChange(_ textView: UITextView) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        updateMemoData(with: textView.text)
        splitVC.updateMemoList(at: currentIndex)
        guard currentIndex != .zero else {
            return
        }
        MemoDataManager.shared.moveMemoList(from: currentIndex, to: .zero)
        splitVC.moveTableViewCell(at: currentIndex)
        currentIndex = .zero
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let titleRange = currentText.range(of: "\n")
        if titleRange.location < range.location {
            textView.typingAttributes = Constant.bodyAttributes
        } else {
            textView.typingAttributes = Constant.headerAttributes
        }
        return true
    }
    
    private func updateMemoData(with text: String) {
        let data = text.split(separator: Constant.lineBreak, maxSplits: 1)
        let lastModified = Date().timeIntervalSince1970
        let title = data[safe: .zero]?.description
        let body = text
        guard let id = MemoDataManager.shared.memoList[safe: currentIndex]?.id else {
            return
        }
        MemoDataManager.shared.updateMemo(id: id, title: title, body: body, lastModified: lastModified)
    }
}
