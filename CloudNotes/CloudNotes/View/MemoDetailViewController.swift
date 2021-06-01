//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/01.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private lazy var isHorizontalSizeClassRegular = UITraitCollection.current.horizontalSizeClass == .regular ? true : false

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()

    override func viewDidLayoutSubviews() {
        descriptionTextView.contentOffset = .zero
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDescriptionTextView()
        addSubviews()
        addConstraints()
    }

    func setDescriptionTextView(text: String) {
        descriptionTextView.text = text
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    private func configureView() {
        view.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
        navigationItem.hidesBackButton = isHorizontalSizeClassRegular
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
    }

    private func configureDescriptionTextView() {
        descriptionTextView.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
    }

    private func addSubviews() {
        view.addSubview(descriptionTextView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
