//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/01.
//

import UIKit
import CoreData

class MemoDetailViewController: UIViewController {
    private var memo: Memo?

    private lazy var isHorizontalSizeClassRegular = UITraitCollection.current.horizontalSizeClass == .regular

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpDescriptionTextView()
    }

    override func viewDidLayoutSubviews() {
        descriptionTextView.contentOffset = .zero
    }

    override func viewWillDisappear(_ animated: Bool) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let memo = memo else { return }
        memo.memoDescription = descriptionTextView.text
        try? context.save()
    }

    func fetchData(memo: Memo) {
        self.memo = memo
        descriptionTextView.text = memo.memoDescription
        descriptionTextView.isEditable = true
    }

    private func setUpView() {
        view.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
        navigationItem.hidesBackButton = isHorizontalSizeClassRegular
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)

        descriptionTextView.backgroundColor = isHorizontalSizeClassRegular ? .systemBackground : .systemGray3
    }

    private func setUpDescriptionTextView() {
        view.addSubview(descriptionTextView)

        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
