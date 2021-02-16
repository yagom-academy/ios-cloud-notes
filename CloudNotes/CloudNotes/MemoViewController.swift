//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

protocol MemoViewControllerDelegate {
    func setMemo(_ memo: String)
}

class MemoViewController: UIViewController {
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.dataDetectorTypes = .all
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(memoTextView)
        memoTextView.delegate = self
        configureConstraints()
        registerKeyboardNotifications()
    }
}

extension MemoViewController {
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeTextViewBottomInsetToKeyboardHeight), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetTextViewBottomInset), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func changeTextViewBottomInsetToKeyboardHeight(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        memoTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: keyboardFrame.height, right: 15)
    }
    
    @objc func resetTextViewBottomInset(_ notification: Notification) {
        memoTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

extension MemoViewController: MemoViewControllerDelegate {
    func setMemo(_ memo: String) {
        memoTextView.text = memo
    }
}

extension MemoViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            view.endEditing(true)
        }
    }
}
