//
//  SecondaryView.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/03.
//

import UIKit

class SecondaryView: UIView {
    let textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = .preferredFont(forTextStyle: .body)
        view.keyboardDismissMode = .interactive
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension SecondaryView: UITextViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        textView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

    }
}

extension SecondaryView {
    func configure(by text: String?) {
        self.textView.text = text
        let beginning = textView.beginningOfDocument
        textView.selectedTextRange = textView.textRange(from: beginning, to: beginning)
    }
}
