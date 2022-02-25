import UIKit

class DetailedNoteViewController: UIViewController {

    // MARK: - Properties

    private var noteData: Content? {
        didSet {
            configureTextView()
        }
    }
    private var shouldCreateNote = false
    private weak var dataSourceDelegate: DetailedNoteViewDelegate?

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

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpController()
    }

    func setDelegate(delegate: DetailedNoteViewDelegate) {
        self.dataSourceDelegate = delegate
    }

    func setNoteData(_ data: Content?) {
        self.noteData = data
    }


    private func setUpController() {
        self.setUpSubView()
        self.view.backgroundColor = .white
    }

    private func setUpSubView() {
        self.configureNavigationBar()
        self.configureHierarchy()
        self.configureConstraints()
        self.setUpTableView()
    }

    private func setUpTableView() {
        self.noteTextView.delegate = self
    }

    @objc
    private func actionButtonDidTap(_ sender: UIBarButtonItem) {
        self.actionSheet.popoverPresentationController?.barButtonItem = sender
        self.present(self.actionSheet, animated: true, completion: nil)
    }

    private func presentActivityController() {
        self.activityController.popoverPresentationController?.barButtonItem = self.actionButton
        self.present(self.activityController, animated: true, completion: nil)
    }

    private func presentDeleteAlert() {
        let alert = UIAlertController(
            title: "메모를 삭제하시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            guard let note = self.noteData
            else {
                return
            }

            self.dataSourceDelegate?.deleteNote(note)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Configure Views

    private func configureHierarchy() {
        self.view.addSubview(noteTextView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.noteTextView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 4),
            self.noteTextView.bottomAnchor.constraint(
                equalTo: self.view.bottomAnchor, constant: -4
            ),
            self.noteTextView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor, constant: 4
            ),
            self.noteTextView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor, constant: -4
            )
        ])
    }

    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = self.actionButton
    }

    private func configureTextView() {
        guard let note = noteData
        else {
            self.setTextViewWithoutNote()

            return
        }

        self.shouldCreateNote = false

        let content = NSMutableAttributedString()

        content.append(self.configuredTitle(for: note))

        if note.body != "" {
            content.append(self.configuredBody(for: note))
        }

        self.noteTextView.attributedText = content
    }

    private func setTextViewWithoutNote() {
        self.noteTextView.text = ""
        self.view.endEditing(true)
        self.shouldCreateNote = true
    }

    private func configuredTitle(for note: Content) -> NSMutableAttributedString {
        let title = NSMutableAttributedString(string: note.title)
        title.addAttribute(
            .font,
            value: UIFont.preferredFont(for: .title3, weight: .medium),
            range: NSRange(location: 0, length: title.length)
        )

        return title
    }

    private func configuredBody(for note: Content) -> NSMutableAttributedString {
        let body = NSMutableAttributedString(string: "\n" + note.body)
        body.addAttribute(
            .font,
            value: UIFont.preferredFont(forTextStyle: .callout),
            range: NSRange(location: 0, length: body.length)
        )

        return body
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
        guard let id = self.noteData?.identification
        else {
            return
        }

        let newNote = Content(
            title: title,
            body: body,
            lastModifiedDate: modifiedDate,
            identification: id
        )
        self.dataSourceDelegate?.passModifiedNote(newNote)
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
