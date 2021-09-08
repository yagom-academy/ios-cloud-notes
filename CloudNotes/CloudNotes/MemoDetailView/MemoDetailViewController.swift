//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class MemoDetailViewController: UIViewController {

    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground

        configureDeleteButton()
        configureTextView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textView.isScrollEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textView.isScrollEnabled = true
    }

    func configure(with memo: Memo?) {
        guard let memo = memo else {
            textView.clear()
            return
        }

        let titlePrefix = "제목 : "
        let descriptionPrefix = "내용 : "
        let doubledNewLine = "\n\n"

        textView.accessibilityLabel = titlePrefix + memo.title
        textView.accessibilityValue = descriptionPrefix + memo.description
        textView.text = memo.title + doubledNewLine + memo.description
    }

    @objc private func confirmToDeleteMemo() {
        let title = "정말 삭제하시겠습니까?"
        let delete = "삭제"
        let cancel = "취소"

        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: cancel, style: .cancel)
        let deleteAction = UIAlertAction(title: delete, style: .destructive)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: false, completion: nil)
    }
}

// MARK: - Draw View
extension MemoDetailViewController {
    private func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)

        view.addSubview(textView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }

    private func configureDeleteButton() {
        let circleImage = UIImage(systemName: "ellipsis.circle")
        let deleteButton = UIBarButtonItem(
            image: circleImage,
            style: .plain,
            target: self,
            action: #selector(confirmToDeleteMemo)
        )
        navigationItem.rightBarButtonItem = deleteButton
    }
}
