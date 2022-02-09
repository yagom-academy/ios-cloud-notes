import UIKit

class DetailedNoteViewController: UIViewController {
    var noteData: Note? {
        didSet {
            configureTextView()
        }
    }

    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .callout)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        return textView
    }()

    let actionButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "ellipsis.circle")

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureConstraints()
        self.view.backgroundColor = .white
    }

    // MARK: - Configure Views

    func configureHierarchy() {
        self.view.addSubview(noteTextView)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 4),
            noteTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
            noteTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4),
            noteTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -4)
        ])
    }

    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = actionButton
    }

    func configureTextView() {
        noteTextView.text = noteData?.body
    }
}
