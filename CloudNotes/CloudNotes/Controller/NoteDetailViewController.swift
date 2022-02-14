import UIKit

class NoteDetailViewController: UIViewController {
    private enum Constant {
        static let lineBreak: Character = "\n"
        static let navigationBarIconName = "ellipsis.circle"
        static let deleteWarningMessage = "정말 삭제하시겠습니까?"
        static let deleteAlertActionTitle = "OK"
        static let headerAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(for: .title1, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        static let bodyAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: UIColor.label
        ]
    }
    private var currentIndex: Int = .zero
    private let noteDetailTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigationItem()
        setUpTextView()
        setUpNotification()
        noteDetailTextView.delegate = self
    }
}

// MARK: - Update
extension NoteDetailViewController {
    func updateData(with index: Int) {
        currentIndex = index
        noteDetailTextView.text = PersistentManager.shared.notes[safe: currentIndex]?.body
        noteDetailTextView.attributedText = configureTextStyle()
    }
    
    func clearTextView() {
        noteDetailTextView.text = nil
    }
}

// MARK: - SetUp Navigation Item
extension NoteDetailViewController {
    private func setUpNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constant.navigationBarIconName),
            style: .plain,
            target: self,
            action: #selector(moreViewbuttonTapped(_:))
        )
    }
    
    @objc func moreViewbuttonTapped(_ sender: UIBarButtonItem) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        self.showNoteActionSheet(shareHandler: { _ in
            self.showActivityViewController(data: PersistentManager.shared.notes[self.currentIndex].body ?? "")
        }, deleteHandler: {_ in
            self.showAlert(
                message: Constant.deleteWarningMessage,
                actionTitle: Constant.deleteAlertActionTitle
            ) { _ in
                splitVC.deleteTableViewCell(
                    indexPath: IndexPath(row: self.currentIndex, section: .zero)
                )
            }
        }, barButtonItem: sender)
    }
}

// MARK: - SetUp UITextView
extension NoteDetailViewController {
    private func setUpTextView() {
        view.addSubview(noteDetailTextView)
        NSLayoutConstraint.activate([
            noteDetailTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteDetailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noteDetailTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteDetailTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = noteDetailTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        noteDetailTextView.contentInset = contentInset
        noteDetailTextView.scrollIndicatorInsets = noteDetailTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        noteDetailTextView.contentInset = UIEdgeInsets.zero
        noteDetailTextView.scrollIndicatorInsets = noteDetailTextView.contentInset
    }
}

// MARK: - UITextView Font Setting
extension NoteDetailViewController {
    private func configureTextStyle() -> NSMutableAttributedString? {
        guard let note = PersistentManager.shared.notes[safe: currentIndex]?.body?.split(
            separator: Constant.lineBreak,
            maxSplits: 1
        ) else {
            return nil
        }
        let titleText = note[safe: 0]?.description
        let bodyText = note[safe: 1]?.description
        
        let attributedString = NSMutableAttributedString()
        let title = attributedText(
            (titleText ?? "") + Constant.lineBreak.description,
            font: .preferredFont(for: .title1, weight: .bold),
            color: .label
        )
        let body = attributedText(
            bodyText ?? "",
            font: .preferredFont(forTextStyle: .body),
            color: .label
        )
        attributedString.append(title)
        attributedString.append(body)
        return attributedString
    }
    
    private func attributedText(_ text: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {
        let string = text as NSString
        let attributedText = NSMutableAttributedString(string: text)
        let range: NSRange = string.range(of: text)
        attributedText.addAttribute(.font, value: font, range: range)
        attributedText.addAttribute(.foregroundColor, value: color, range: range)
        return attributedText
    }
}

// MARK: - TextViewDelegate
extension NoteDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let titleRange = currentText.range(of: Constant.lineBreak.description)
        if titleRange.location < range.location {
            textView.typingAttributes = Constant.bodyAttributes
        } else {
            textView.typingAttributes = Constant.headerAttributes
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let splitVC = self.splitViewController as? SplitViewController else {
            return
        }
        updateNoteData(with: textView.text)
        splitVC.updateNotes(at: currentIndex)
        guard currentIndex != .zero else {
            return
        }
        PersistentManager.shared.moveNotes(from: currentIndex, to: .zero)
        splitVC.moveTableViewCell(at: currentIndex)
        currentIndex = .zero
    }
    
    private func updateNoteData(with text: String) {
        let data = text.split(separator: Constant.lineBreak, maxSplits: 1)
        let lastModified = Date().timeIntervalSince1970
        let title = data[safe: .zero]?.description
        let body = text
        guard let id = PersistentManager.shared.notes[safe: currentIndex]?.id else {
            return
        }
        PersistentManager.shared.updateNote(id: id, title: title, body: body, lastModified: lastModified)
    }
}
