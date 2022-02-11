import UIKit

final class DetailViewController: UIViewController {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
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
    
    func applyData(with description: String) {
        textView.text = description
    }
}
