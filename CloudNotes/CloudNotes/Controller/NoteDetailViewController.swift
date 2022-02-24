import UIKit
// MARK: - Declare NoteDetailViewControllerDelegate
protocol NoteDetailViewControllerDelegate: AnyObject {
    func noteDetailViewController(_ viewController: UIViewController, didChangeBody body: String)
    
    func noteDetailViewController(didTapRightBarButton viewController: UIViewController, sender: AnyObject)
}

class NoteDetailViewController: UIViewController {
    // MARK: - Property
    weak var delegate: NoteDetailViewControllerDelegate?
    private var textView: UITextView = {
        let textview = UITextView(frame: .zero)
        textview.font = .preferredFont(forTextStyle: .caption1)
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    // MARK: - ViewLifeCycle
    override func loadView() {
        view = .init()
        view.backgroundColor = .white
        view.addSubview(textView)
        textView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextViewLayout()
        setUpNavigationItems()
        textView.selectedRange = NSRange("\n") ?? NSRange()
    }
    // MARK: - Method
    func setUpText(with data: MemoType) {
        guard let title = data.title, let body = data.body else {
             return
        }
        textView.text = "\(title)\n\(body)"
    }
    
    private func setUpNavigationItems() {
        let circleImage = UIImage(systemName: "ellipsis.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: circleImage,
            style: .plain,
            target: nil,
            action: #selector(tappedShareButton(sender: ))
        )
    }
    
    @objc private func tappedShareButton(sender: AnyObject) {
        delegate?.noteDetailViewController(didTapRightBarButton: self, sender: sender)
    }
    
    private func setUpTextViewLayout() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
// MARK: - UITextView Delegate
extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let body = textView.text ?? "" 
        delegate?.noteDetailViewController(self, didChangeBody: body)
    }
}
