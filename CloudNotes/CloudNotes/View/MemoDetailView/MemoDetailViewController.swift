//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import UIKit

protocol Memorizable: NSObject {
    func update()
}

class MemoDetailViewController: UIViewController, RootViewControllerable {
    weak var delegate: Memorizable?
    private var memo: Memo?
    private let memoView = MemoDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureTextField()
    }

    func setup() {
        self.view = memoView
        memoView.detailTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
            memoView.detailTextView.contentInset = contentInsets
            memoView.detailTextView.verticalScrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        memoView.detailTextView.contentInset = contentInsets
        memoView.detailTextView.verticalScrollIndicatorInsets = contentInsets
    }

    func configure(with memo: Memo) {
        self.memo = memo
    }
}

private extension MemoDetailViewController {
    func configureTextField() {
        memo.flatMap { memoView.detailTextView.text = $0.title + "\n\n" + $0.body }
        scrollToTop()
    }

    func scrollToTop() {
        let contentHeight = memoView.detailTextView.contentSize.height
        let offSet = memoView.detailTextView.contentOffset.x
        let contentOffset = contentHeight - offSet
        memoView.detailTextView.contentOffset = CGPoint(x: 0, y: -contentOffset)
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let minumumLine = 3
        let title = textView.text.lines[0]
        var body = ""
        if minumumLine <= textView.text.lines.count {
            body = textView.text.lines[(minumumLine - 1)...].joined(separator: "\n")
        }
        memo?.update(with: Memo(title: title, body: body, lastDate: Date().timeIntervalSince1970))
        delegate?.update()
    }
}
