//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class ContentViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView = MemoTextView()
    
    private let doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = doneButton
        
        setUpScrollView()
        setUpContentView()
        setUpViewPropertyConstraints()
        setUpTextViewDelegation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func didTapMemoItem(with memo: Memo) {
        updateUI(with: memo)
    }
    
    private func setUpScrollView() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(scrollView)
        scrollView.backgroundColor = .brown
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    private func setUpContentView() {
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let heightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.isActive = true
    }
    
    private func setUpViewPropertyConstraints() {
        contentView.isScrollEnabled = false
        contentView.isSelectable = true
        contentView.isEditable = false
        contentView.isUserInteractionEnabled = true
        contentView.dataDetectorTypes = .all
    }
}
extension ContentViewController {
    private func setUpTextViewDelegation() {
        contentView.delegate = self
        textViewDidChange(contentView)
    }
    
    
    private func updateUI(with memo: Memo) {
        contentView.text = "\(memo.title)\n \(memo.body)"
        setUpContentView()
    }
}
extension ContentViewController: UIGestureRecognizerDelegate {
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        scrollView.contentInset.bottom = keyboardFrame.size.height
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}
extension ContentViewController: UITextViewDelegate {
    @objc private func didTapDoneButton(_ sender: Any) {
        self.contentView.endEditing(true)
        self.contentView.isEditable = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.view.frame.width, height: .infinity)
        let rearrangedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = rearrangedSize.height
            }
        }
        
        let heightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.isActive = true
    }
}
