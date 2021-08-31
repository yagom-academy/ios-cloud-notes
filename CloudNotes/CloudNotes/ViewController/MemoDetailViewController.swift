//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private var memo: Memo?
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.systemGray4
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.allowsEditingTextAttributes = true
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(memoTextView)
        configureTextField()
    }

    func configure(with memo: Memo) {
        self.memo = memo
    }
}

private extension MemoDetailViewController {
    func configureTextField() {
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        let textFieldConstraints = [
            memoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            memoTextView.topAnchor.constraint(equalTo: view.topAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)

        memo.flatMap { memoTextView.text = $0.title + "\n\n" + $0.body }

        let contentHeight = memoTextView.contentSize.height
        let offSet = memoTextView.contentOffset.x
        let contentOffset = contentHeight - offSet
        memoTextView.contentOffset = CGPoint(x: 0, y: -contentOffset)
    }
}
