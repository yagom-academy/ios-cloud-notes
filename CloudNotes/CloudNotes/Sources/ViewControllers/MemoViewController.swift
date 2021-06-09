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

    // MARK: UI

    private let moreActionButton = UIBarButtonItem(title: "more", image: UIImage(systemName: "ellipsis.circle") ?? UIImage(), primaryAction: nil, menu: nil)

    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isEditable = true
        textView.isHidden = true
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
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
        configureBackgroundColor(by: traitCollection.horizontalSizeClass)
        configureTextView()
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        configureBackgroundColor(by: newCollection.horizontalSizeClass)
    }

    // MARK: Configure

    func configure(row: Int, memo: Memo) {
        self.row = row

        guard memo.title != "" else { return textView.text = nil }
        textView.text = "\(memo.title)\n\(memo.body)"

        let topOffset = CGPoint(x: 0, y: -view.safeAreaInsets.top)
        textView.setContentOffset(topOffset, animated: false)
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
        view.backgroundColor = (sizeClass == .compact) ? .systemGray3 : .systemBackground
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

    func setTextViewHidden(is value: Bool) {
        textView.isHidden = value
    }

}

// MARK: - UISplitViewControllerDelegate

extension MemoViewController: UISplitViewControllerDelegate {

    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return textView.isHidden ? .primary : .secondary
    }

}

// MARK: - UITextViewDelegate

extension MemoViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard let textViewText = textView.text else { return }
        let text: [Substring] = textViewText.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)

        var newTitle: String = ""
        var newBody: String = ""

        switch text.count {
        case 0:
            break
        case 1:
            newTitle = String(text[0])
        case 2:
            newTitle = String(text[0])
            newBody = String(text[1])
        default:
            return
        }

        self.memo = Memo(title: newTitle, body: newBody, lastModified: Date().timeIntervalSince1970)

        let primaryViewController = splitViewController?.viewController(for: .primary) as? MemoListViewController

        if let memo = memo,
           let row = row {
            primaryViewController?.updateMemo(at: row, to: memo)
            self.row = 0
        }
    }

}
