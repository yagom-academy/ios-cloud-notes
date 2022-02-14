import UIKit

class DetailedNoteViewController: UIViewController {
    private var noteData: Content? {
        didSet {
            configureTextView()
        }
    }
    private weak var dataSourceDelegate: DetailedNoteViewDelegate?

    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        return textView
    }()

    private let actionButton: UIBarButtonItem = {
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
        self.noteTextView.delegate = self
    }

    func setDelegate(delegate: DetailedNoteViewDelegate) {
        self.dataSourceDelegate = delegate
    }

    func setNoteData(_ data: Content?) {
        self.noteData = data
    }

    // MARK: - Configure Views

    private func configureHierarchy() {
        self.view.addSubview(noteTextView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 4),
            noteTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
            noteTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4),
            noteTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -4)
        ])
    }

    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = actionButton
    }

    private func configureTextView() {
        guard let note = noteData else {
            return
        }
        let content = NSMutableAttributedString()
        let title = NSMutableAttributedString(string: note.title)
        let body = NSMutableAttributedString(string: "\n" + note.body)
        title.addAttribute(
            .font, value: UIFont.preferredFont(for: .title3, weight: .medium),
            range: NSRange(location: 0, length: title.length)
        )
        body.addAttribute(
            .font, value: UIFont.preferredFont(forTextStyle: .callout),
            range: NSRange(location: 0, length: body.length)
        )
        content.append(title)
        content.append(body)

        noteTextView.attributedText = content
    }
}

extension DetailedNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        var content = textView.text.components(separatedBy: ["\n"])
        var title = content.removeFirst()
        var body = content.joined(separator: "")

        if title.count > 100 {
            title = String(textView.text.prefix(100))
            body = String(textView.text.suffix(textView.text.count - 100))
        }

        let modifiedDate = Date().timeIntervalSince1970
        let newNote = Content(title: title, body: body, lastModifiedDate: modifiedDate)

        dataSourceDelegate?.passModifiedNote(note: newNote)
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String
    ) -> Bool {
        let originalText = self.noteTextView.text as NSString
        let replacedText = originalText.replacingCharacters(in: range, with: text) as NSString
        let titleRange = replacedText.range(of: "\n")
        if titleRange.location <= range.location {
            self.noteTextView.typingAttributes = [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout)
            ]
        } else {
            self.noteTextView.typingAttributes = [
                NSAttributedString.Key.font: UIFont.preferredFont(for: .title3, weight: .medium)
            ]
        }

        return true
    }
}
