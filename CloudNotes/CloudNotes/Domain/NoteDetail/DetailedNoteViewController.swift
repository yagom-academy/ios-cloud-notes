import UIKit

class DetailedNoteViewController: UIViewController {
    private var noteData: Content? {
        didSet {
            configureTextView()
        }
    }
    private weak var dataSourceDelegate: DetailedNoteViewDelegate?
    private var shouldCreateNote = false

    // MARK: - View Component

    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        return textView
    }()

    private lazy var actionButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "ellipsis.circle")
        button.target = self
        button.action = #selector(actionButtonDidTap)
        return button
    }()

    private lazy var activityController: UIActivityViewController = {
        let controller = UIActivityViewController(
            activityItems: ["memo"],
            applicationActivities: nil
        )
        return controller
    }()

    private lazy var actionSheet: UIAlertController = {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "공유", style: .default) { _ in
            self.presentActivityController()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.presentDeleteAlert()
        }

        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)

        return actionSheet
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHierarchy()
        configureConstraints()
        self.view.backgroundColor = .white
        self.noteTextView.delegate = self
    }

    // MARK: - Action Method

    @objc func actionButtonDidTap(_ sender: UIBarButtonItem) {
        actionSheet.popoverPresentationController?.barButtonItem = sender
        self.present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - Present Method

    func presentActivityController() {
        activityController.popoverPresentationController?.barButtonItem = actionButton
        self.present(activityController, animated: true, completion: nil)
    }

    func presentDeleteAlert() {
        let alert = UIAlertController(
            title: "메모를 삭제하시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            guard let note = self.noteData else {
                return
            }

            self.dataSourceDelegate?.deleteNote(note)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Set Delegate Method

    func setDelegate(delegate: DetailedNoteViewDelegate) {
        self.dataSourceDelegate = delegate
    }

    // MARK: - Manipulate DataSource

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
            noteTextView.text = ""
            self.view.endEditing(true)
            self.shouldCreateNote = true
            return
        }
        self.shouldCreateNote = false
        let content = NSMutableAttributedString()
        let title = NSMutableAttributedString(string: note.title)
        title.addAttribute(
            .font, value: UIFont.preferredFont(for: .title3, weight: .medium),
            range: NSRange(location: 0, length: title.length)
        )
        content.append(title)

        if note.body != "" {
            let body = NSMutableAttributedString(string: "\n" + note.body)
            body.addAttribute(
                .font, value: UIFont.preferredFont(forTextStyle: .callout),
                range: NSRange(location: 0, length: body.length)
            )
            content.append(body)
        }

        noteTextView.attributedText = content
    }
}

// MARK: - Text View Delegate

extension DetailedNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.shouldCreateNote {
            self.dataSourceDelegate?.creatNote()
            self.shouldCreateNote = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        var content = textView.text.components(separatedBy: ["\n"])
        var title = content.removeFirst()
        var body = content.joined(separator: "\n")
        if title.count > 100 {
            title = String(textView.text.prefix(100))
            body = String(textView.text.suffix(textView.text.count - 100))
        }

        let modifiedDate = Date().timeIntervalSince1970
        guard let id = self.noteData?.identification else {
            return
        }

        let newNote = Content(
            title: title,
            body: body,
            lastModifiedDate: modifiedDate,
            identification: id
        )
        dataSourceDelegate?.passModifiedNote(newNote)
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
