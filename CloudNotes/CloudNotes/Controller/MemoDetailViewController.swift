//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private let memoDeatailTextView = UITextView()
    private var currentMemo: Memo?
    private let linebreak = "\n"
    var delegate: MemoSendable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(memoDeatailTextView)
        configureTextView()
        setLayoutForTextView()
        memoDeatailTextView.delegate = self
    }
    
    func configureTextView(by memo: Memo) {
        memoDeatailTextView.text = memo.title + linebreak + memo.body
    }
    
    private func configureTextView() {
        memoDeatailTextView.translatesAutoresizingMaskIntoConstraints = false
        memoDeatailTextView.autocorrectionType = .no
        memoDeatailTextView.backgroundColor = .secondarySystemBackground
        memoDeatailTextView.textColor = .secondaryLabel
    }
    
    private func setLayoutForTextView() {
        NSLayoutConstraint.activate([memoDeatailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     memoDeatailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     memoDeatailTextView.topAnchor.constraint(equalTo: view.topAnchor),
                                     memoDeatailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let lastIndex = Int(textView.text.components(separatedBy: linebreak).count - 1)
        let title = textView.text.components(separatedBy: linebreak)[.zero]
        let body = textView.text.components(separatedBy: linebreak)[1...lastIndex].joined(separator: linebreak)
        let now = Date()
        delegate?.sendToListVC(memo: Memo.init(title: title, body: body, lastModified: now))
    }
}
