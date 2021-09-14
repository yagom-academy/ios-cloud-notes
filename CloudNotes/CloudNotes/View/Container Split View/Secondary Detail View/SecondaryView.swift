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
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - Keyboard Notification
extension SecondaryView {
    @objc func keyboardWasShown(_ notification: Notification) {
        if let info = notification.userInfo,
           let keyboardSize = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            textView.contentInset = contentInset
            textView.scrollIndicatorInsets = contentInset
            
            var currentFrame = self.frame
            currentFrame.size.height -= keyboardSize.height
            if !currentFrame.contains(textView.contentOffset) {
                let selectedRange = textView.selectedRange
                textView.scrollRangeToVisible(selectedRange)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        textView.contentInset = contentInsets
        textView.scrollIndicatorInsets = contentInsets
        textView.resignFirstResponder()
    }
}

extension SecondaryView {
    func configure(by text: String?) {
        self.textView.text = text
        textView.setContentOffset(.zero, animated: true)
    }
}
