//
//  SecondaryView.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/03.
//

import UIKit

class SecondaryView: UIView {
    typealias EndEditingAction = (String) -> Void
    
    private var endEditingAction: EndEditingAction?
    
    let textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = .preferredFont(forTextStyle: .body)
        view.keyboardDismissMode = .interactive
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(endEditingAction: @escaping EndEditingAction) {
        super.init(frame: .zero)
        self.endEditingAction = endEditingAction
        addSubview(textView)
        self.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension SecondaryView: UITextViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        textView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        endEditingAction?(textView.text)
    }
}

extension SecondaryView {
    func configure(by text: String?) {
        self.textView.text = text
        let beginning = textView.beginningOfDocument
        textView.selectedTextRange = textView.textRange(from: beginning, to: beginning)
    }
}
