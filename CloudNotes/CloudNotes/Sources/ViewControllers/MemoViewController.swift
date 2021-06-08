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
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isEditable = true
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
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTextView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        memo = nil
    }

    // MARK: Configure

    func configure(row: Int, memo: Memo) {
        self.row = row

        guard memo.title != "" else { return textView.text = nil }
        textView.text = "\(memo.title)\n\(memo.body)"

        let topOffset = CGPoint(x: 0, y: -view.safeAreaInsets.top)
        textView.setContentOffset(topOffset, animated: false)
    }

    func textViewResignFirstResponder() {
        textView.resignFirstResponder()
    }

    private func configureTextView() {
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: Keyboard observing

    @objc func textViewMoveUp(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = contentInset
    }

    @objc func textViewMoveDown(_ notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = contentInset
    }

}
