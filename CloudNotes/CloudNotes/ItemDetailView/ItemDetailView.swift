//
//  ContentsController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class ItemDetailView: UIViewController {

    lazy var textView: UITextView = createdTextView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.isScrollEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.isScrollEnabled = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        textView.text = nil
    }

    func configure(_ memo: Memo) {
        let doubledNewLine = "\n\n"
        textView.text = memo.title + doubledNewLine + memo.description
    }
}

extension ItemDetailView {
    func createdTextView() -> UITextView {
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

        txtView.setContentOffset(CGPoint(x: 0, y: Int.max), animated: false)

        return txtView
    }
}


extension ItemDetailView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.keyboardAppearance 
    }
}
