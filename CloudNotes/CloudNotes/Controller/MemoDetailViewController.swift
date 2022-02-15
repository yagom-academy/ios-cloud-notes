import UIKit

protocol MemoDetailViewControllerDelegate: AnyObject {
    func memoDetailViewController(showTextViewWith memo: Memo)
}

class MemoDetailViewController: UIViewController {
    weak var delegate: MemoListViewControllerDelegate?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var currentMemo: Memo {
        let memoComponents = textView.text.split(
            separator: "\n",
            maxSplits: 1
        ).map(String.init)
        
        let title = memoComponents[safe: 0] ?? ""
        let body = memoComponents[safe: 1] ?? ""
        let date = Date()
        
        return Memo(title: title, body: body, lastModified: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTextView()
        setupNavigationItem()
        memoDetailViewController(showTextViewWith: MemoDataManager.shared.memos[0])
        textView.delegate = self
        setUpNotification()
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
        guard let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {return}

        let keyboardRect = keyboardFrame.cgRectValue
        textView.contentInset.bottom = keyboardRect.height
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(showActivityView)
        )
    }
    
    @objc func showActivityView() {
        print("AA")
    }
    
}

// MARK: MemoDetailViewControllerDelegate

extension MemoDetailViewController: MemoDetailViewControllerDelegate {
    func memoDetailViewController(showTextViewWith memo: Memo) {
        textView.text = "\(memo.title)\n\(memo.body)"
    }
}

// MARK: UITextViewDelegate

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.memoListViewController(updateTableViewCellWith: currentMemo)
    }
}
