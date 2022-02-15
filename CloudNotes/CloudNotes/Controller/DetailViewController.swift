import UIKit

final class DetailViewController: UIViewController {
    var memo: Memo?
   
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
        textView.delegate = self
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
        // ActivityView 나타내기
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            
            let title = "Jokes Are Us Diagnostics:"
            let text = "Some Text"
            
            let textToShare: [Any] = [ title ]
            let acitivityView = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                        
            let alertPopover = acitivityView.popoverPresentationController
            alertPopover?.barButtonItem = self.navigationItem.rightBarButtonItem
            
            self.present(acitivityView, animated: true, completion: nil)
        }
        
        // 삭제 Alert 나타내기
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                CoreDataManager.shared.deleteMemo(memoId: self.memo?.memoId)
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
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension DetailViewController: MemoSelectionDelegate {
    var memoSelectionDestination: UIViewController {
        return self
    }
    
    func applyData(with data: Memo) {
        memo = data
        updateTextView()
    }
    
    func updateTextView() {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        
        let titleAttributedText = NSAttributedString(string: memo?.title ?? "", attributes: titleAttributes)
        let bodyAattributedText = NSAttributedString(string: "\n\(memo?.body ?? "")", attributes: bodyAttributes)
        
        textView.attributedText = titleAttributedText
        textView.textStorage.append(bodyAattributedText)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        
        let textAsNSString = textView.text as NSString
        let titleRange = textAsNSString.range(of: "\n")
        
        if titleRange.location >= range.location {
            self.textView.typingAttributes = titleAttributes
        } else {
            self.textView.typingAttributes = bodyAttributes
        }
        
        return true
    }
}
