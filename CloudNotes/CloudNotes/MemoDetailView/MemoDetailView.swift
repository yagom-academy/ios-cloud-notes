//
//  MemoDetailView.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class MemoDetailView: UIViewController {

    private lazy var textView: UITextView = createdTextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let systemImageName = "ellipsis.circle"
        let circleImage = UIImage(systemName: systemImageName)
        let deleteButton = UIBarButtonItem(
            image: circleImage,
            style: .plain,
            target: self,
            action: #selector(confirmToDeleteMemo)
        )
        navigationItem.rightBarButtonItem = deleteButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textView.isScrollEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.isScrollEnabled = true

        textView.becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        textView.text = nil
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
        let deleteAction = UIAlertAction(title: delete, style: .destructive) { _ in

        }

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: false, completion: nil)
    }
}

extension MemoDetailView {
    private func createdTextView() -> UITextView {
        let txtView = UITextView()
        txtView.tag = 1
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.font = UIFont.preferredFont(forTextStyle: .body)

        view.addSubview(txtView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            txtView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            txtView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            txtView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            txtView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        txtView.delegate = self

        return txtView
    }
}

extension MemoDetailView: UITextViewDelegate {

}
