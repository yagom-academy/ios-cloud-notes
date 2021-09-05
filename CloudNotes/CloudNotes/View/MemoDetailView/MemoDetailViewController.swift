//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import UIKit

protocol Memorizable: NSObject {
    func updateMemo(with newMemo: Memo, index: Int)
}

class MemoDetailViewController: RootViewController {
    weak var delegate: Memorizable?
    private var memo: Memo?
    private var index: Int?
    private let memoView = MemoDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }

    override func setup() {
        self.view = memoView
        memoView.detailTextView.delegate = self
    }

    func configure(with memo: Memo, index: Int) {
        self.memo = memo
        self.index = index
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
        guard let index = index else { return }
        let minumumLine = 3
        let title = textView.text.lines[0]
        var body = ""
        if minumumLine <= textView.text.lines.count {
            body = textView.text.lines[(minumumLine - 1)...].joined(separator: "\n")
        }
        delegate?.updateMemo(with: Memo(title: title, body: body, lastDate: Date().timeIntervalSince1970), index: index)
    }
}
