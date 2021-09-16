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
    private let firstIndex = 1
    private var workItem: DispatchWorkItem?
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
    
    private func configureDebounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        guard let validWorkItem = workItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: validWorkItem)
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        configureDebounce { [self] in
            let lastIndex = Int(textView.text.components(separatedBy: linebreak).count - firstIndex)
            let title = textView.text.components(separatedBy: linebreak)[.zero]
            let body = textView.text.components(separatedBy: linebreak)[firstIndex...lastIndex].joined(separator: linebreak)
            let now = Date()
            delegate?.textViewModify(at: Memo.init(title: title, body: body, lastModified: now))
        }
    }
}
