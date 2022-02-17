import UIKit

protocol NoteDetailViewControllerDelegate: AnyObject {
    func noteDetailViewController(_ viewController: UIViewController, bodyForUpdate body: String)
}

class NoteDetailViewController: UIViewController {
    weak var delegate: NoteDetailViewControllerDelegate?
    private var textView: UITextView = {
        let textview = UITextView(frame: .zero)
        textview.font = .preferredFont(forTextStyle: .caption1)
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
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
    
    func setUpText(with data: CDMemo) {
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
            action: nil
        )
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

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let body = textView.text ?? "" // date를 업데이트
        delegate?.noteDetailViewController(self, bodyForUpdate: body)
    }
}
