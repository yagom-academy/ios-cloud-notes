//
//  ContentsController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class MemoDetailView: UIViewController {

    private lazy var textView: UITextView = createdTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if textView.text.isEmpty {
            textView.becomeFirstResponder()
        }

        textView.isScrollEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.isScrollEnabled = true
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
}

extension MemoDetailView {
    private func createdTextView() -> UITextView {
        let txtView = UITextView()
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

        return txtView
    }
}

extension MemoDetailView: UITextViewDelegate {

}
