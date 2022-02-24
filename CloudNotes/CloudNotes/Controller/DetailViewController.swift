import UIKit

final class DetailViewController: UIViewController {
    private var memo: MemoEntity?

    private let textView: UITextView = {
        let textView = UITextView()
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureKeyboardNotificationCenter()
    }
    
    private func configureUI() {
        configureContentView()
        configureNavigationBar()
        configureTextView()
    }
    
    private func configureKeyboardNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo as NSDictionary? else {
            return
        }
        
        guard let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
       
        textView.contentInset.bottom = keyboardHeight
    }
    
    private func configureContentView() {
        view.backgroundColor = .white
    }
    
    private func configureNavigationBar() {
        let detailButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(touchUpDetailButton))
        navigationItem.rightBarButtonItem = detailButton
    }
    
    @objc private func touchUpDetailButton() {
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            let title = self.memo?.title
            let textToShare: [Any] = [title as Any]
            let acitivityView = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                        
            let alertPopover = acitivityView.popoverPresentationController
            alertPopover?.barButtonItem = self.navigationItem.rightBarButtonItem
            
            self.present(acitivityView, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.textView.text = nil
                NotificationCenter.default.post(name: Notification.Name("didDeleteMemo"), object: nil)
            }
            
            let alert = AlertFactory().createAlert(style: .alert, title: "진짜요?", message: "정말로 삭제하시겠어요?", actions: cancelAction, deleteAction)
            
            self.present(alert, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = AlertFactory().createAlert(style: .actionSheet, title: nil, message: nil, actions: shareAction, deleteAction, cancelAction)
        let alertPopover = alert.popoverPresentationController
        alertPopover?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(alert, animated: true)
    }
    
    private func configureTextView() {
        textView.delegate = self
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func createMemoToUpdate() -> MemoEntity? {
        let texts = textView.text.split(separator: "\n", maxSplits: 1)
        let strings = texts.map { String($0) }
        var titleText: String?
        var bodyText: String?
        
        if texts.count == 2 {
            titleText = strings[0]
            bodyText = strings[1]
        } else if texts.count == 1 {
            titleText = strings[0]
        }

        let currentTime = NSDate().timeIntervalSince1970
        guard let memoId = memo?.memoId else {
            return nil
        }
        
        let memoToUpdate = TemporaryMemo(title: titleText, body: bodyText, lastModifiedDate: currentTime, memoId: memoId)
        
        return memoToUpdate
    }
    
    private func updateTextView() {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1),
                               NSAttributedString.Key.foregroundColor: UIColor.label]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                              NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let totalAttributedText = NSMutableAttributedString()
        let titleAttributedText = NSMutableAttributedString(string: memo?.title ?? "", attributes: titleAttributes)
        let bodyAattributedText = NSMutableAttributedString(string: "\n\n\(memo?.body ?? "")", attributes: bodyAttributes)
        
        totalAttributedText.append(titleAttributedText)
        totalAttributedText.append(bodyAattributedText)
        
        textView.attributedText = totalAttributedText
    }
}

extension DetailViewController: MemoSelectionDelegate {
    var memoSelectionDestination: UIViewController {
        return self
    }
    
    func applyData(with data: MemoEntity) {
        memo = data
        updateTextView()
    }
    
    func clearTextView() {
        textView.text = nil
    }
}

extension DetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1),
                               NSAttributedString.Key.foregroundColor: UIColor.label]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                              NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let textAsNSString = textView.text as NSString
        let titleRange = textAsNSString.range(of: "\n")
        
        if titleRange.location >= range.location {
            textView.typingAttributes = titleAttributes
        } else {
            textView.typingAttributes = bodyAttributes
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let memoToUpdate = createMemoToUpdate()
        NotificationCenter.default.post(name: Notification.Name("didChangeTextView"), object: nil, userInfo: ["memo": memoToUpdate as Any])
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DropBoxManager().uploadToDropBox()
    }
}
