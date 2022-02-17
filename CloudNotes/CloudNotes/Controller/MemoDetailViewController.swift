import UIKit

protocol MemoDetailViewControllerDelegate: AnyObject {
    func memoDetailViewController(showTextViewWith memo: Memo)
    func showEmptyTextView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTextView()
        setupNavigationItem()
        if !MemoDataManager.shared.isEmpty {
            memoDetailViewController(showTextViewWith: MemoDataManager.shared.memos[0])
        }
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
        guard let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(viewMoreButtonTapped))
    }
    
    @objc func viewMoreButtonTapped(_ sender: UIBarButtonItem) {
        makeAlert(sender)
    }
    
    func makeAlert(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "Share...", style: .default) { _ in
            self.showActivityView(sender)
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showDeleteAlert(sender)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(share)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showActivityView(_ sender: UIBarButtonItem) {
        guard let textToShare = textView.text else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        present(activityViewController, animated: true)
    }
    
    func showDeleteAlert(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.delegate?.deleteTableViewCell()
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
}

// MARK: MemoDetailViewControllerDelegate

extension MemoDetailViewController: MemoDetailViewControllerDelegate {
    func memoDetailViewController(showTextViewWith memo: Memo) {
        let title = memo.title ?? ""
        let body = memo.body ?? ""
        
        if title.isEmpty && body.isEmpty {
            textView.text = ""
            return
        }
        textView.text = "\(title)\n\(body)"
    }
    
    func showEmptyTextView() {
        textView.isEditable = false
        textView.text = ""
    }
}

// MARK: UITextViewDelegate

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let memoComponents = textView.text.split(
            separator: "\n",
            maxSplits: 1
        ).map(String.init)
        
        let title = memoComponents[safe: 0] ?? ""
        let body = memoComponents[safe: 1] ?? ""
        let lastModified = Date()
        
        delegate?.memoListViewController(updateTableViewCellWith: title, body: body, lastModified: lastModified)
    }
}
