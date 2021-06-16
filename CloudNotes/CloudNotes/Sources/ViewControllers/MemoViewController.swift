//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/02.
//

import UIKit

final class MemoViewController: UIViewController {

    // MARK: Property

    private var row: Int?
    private var memo: Memo?

    var isTextViewHidden: Bool {
        get { textView.isHidden }
        set { textView.isHidden = newValue }
    }

    // MARK: UI

    private let moreActionButton = UIBarButtonItem(title: Style.moreActionButtonTitle, image: Style.moreActionButtonImage, primaryAction: nil, menu: nil)

    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = Style.textViewBackgroundColor
        textView.font = Style.textViewFont
        textView.isEditable = true
        textView.isHidden = true
        textView.textContainerInset = Style.textViewTextContainerInset
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.setRightBarButton(moreActionButton, animated: true)

        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundColor(by: traitCollection.horizontalSizeClass)
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        configureBackgroundColor(by: newCollection.horizontalSizeClass)
    }

    // MARK: Configure

    func configure(row: Int, memo: Memo) {
        self.row = row
        configureTextViewText(by: memo)
        resetScrollOffset()
    }

    private func configureTextView() {
        textView.delegate = self

        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureBackgroundColor(by sizeClass: UIUserInterfaceSizeClass) {
        view.backgroundColor = (sizeClass == .compact) ? Style.compactViewBackgroundColor : Style.commonViewBackgroundColor
    }

    private func configureTextViewText(by memo: Memo) {
        guard false == memo.title.isEmpty else {
            return textView.text = nil
        }

        textView.text = memo.title + "\(Style.memoSeparator)" + memo.body
    }

    private func resetScrollOffset() {
        let topOffset = CGPoint(x: 0, y: -view.safeAreaInsets.top)
        textView.setContentOffset(topOffset, animated: false)
    }

    // MARK: Keyboard observing

    @objc private func textViewMoveUp(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = contentInset
    }

    @objc private func textViewMoveDown() {
        let contentInset = UIEdgeInsets.zero
        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = contentInset
    }

    // MARK: Method

    func textViewResignFirstResponder() {
        textView.resignFirstResponder()
    }

}

// MARK: - UITextViewDelegate

extension MemoViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard let textViewText = textView.text,
              let seperatedMemo = separatedMemo(from: textViewText) else { return }

        self.memo = Memo(title: seperatedMemo.title, body: seperatedMemo.body)

        let primaryViewController = splitViewController?.viewController(for: .primary) as? MemoListViewController

        if let row = row,
           let memo = memo {
            primaryViewController?.updateMemo(at: row, to: memo)
            self.row = Style.updatedMemoRow
        }
    }

    private func separatedMemo(from text: String) -> (title: String, body: String)? {
        let separatedText: [Substring] = text.split(separator: Style.memoSeparator, maxSplits: 1, omittingEmptySubsequences: true)
        return (String(separatedText.first ?? ""), String(separatedText.last ?? ""))
    }

}

// MARK: - Style

extension MemoViewController {

    enum Style {
        static let moreActionButtonTitle: String = "more"
        static let moreActionButtonImage: UIImage = UIImage(systemName: "ellipsis.circle") ?? .actions

        static let textViewBackgroundColor: UIColor = .clear
        static let textViewFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
        static let textViewTextContainerInset: UIEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

        static let commonViewBackgroundColor: UIColor = .systemBackground
        static let compactViewBackgroundColor: UIColor = .systemGray3

        static let updatedMemoRow: Int = 0

        static let memoSeparator: Character = "\n"
    }

}
