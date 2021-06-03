//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/02.
//

import UIKit

final class MemoViewController: UIViewController {

    // MARK: Property

     private var memo: Memo? {
         didSet {
             guard let memo = memo else { return textView.text = nil }
             textView.text = "\(memo.title)\n\n\(memo.body)"
         }
     }

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

    func configure(memo: Memo?) {
        self.memo = memo
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

}
