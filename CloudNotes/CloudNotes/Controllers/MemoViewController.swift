//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

class MemoViewController: UIViewController {
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(memoTextView)
        memoTextView.delegate = self
        configureConstraints()
        registerKeyboardNotifications()
        configureGesture()
    }
    
    @objc func enterEditMode() {
        memoTextView.isEditable = true
        tapGesture?.isEnabled = false
        memoTextView.becomeFirstResponder()
    }
    
    @objc func exitEditMode() {
        memoTextView.isEditable = false
        tapGesture?.isEnabled = true
        memoTextView.resignFirstResponder()
    }

}

// MARK:- Configure
extension MemoViewController {
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    private func configureGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(enterEditMode))
        if let tapGesture = self.tapGesture {
            memoTextView.addGestureRecognizer(tapGesture)
        }
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(exitEditMode))
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
        memoTextView.addGestureRecognizer(swipeDownGesture)
    }
    func setMemo(_ memo: String) {
        memoTextView.text = memo
    }
}

// MARK:- Keyboard 관련
extension MemoViewController {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeTextViewBottomInsetToKeyboardHeight), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetTextViewBottomInset), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func changeTextViewBottomInsetToKeyboardHeight(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height , right: 0)
        memoTextView.contentInset = contentInsets
    }
    
    @objc func resetTextViewBottomInset(_ notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        memoTextView.contentInset = contentInsets
    }
}

extension MemoViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            exitEditMode()
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
