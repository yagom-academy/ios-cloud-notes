//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class ContentViewController: UIViewController {
    let contentView = UIView()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        return scrollView
    }()
    lazy var titleTextView: UITextView = {
        let titleTextView = UITextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.font = .preferredFont(forTextStyle: .headline)
        titleTextView.adjustsFontForContentSizeCategory = true
        return titleTextView
    }()
    lazy var bodyTextView: UITextView = {
        let bodyTextView = UITextView()
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.font = .preferredFont(forTextStyle: .body)
        bodyTextView.adjustsFontForContentSizeCategory = true
        return bodyTextView
    }()
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = doneButton
        setUpContentView()
        setUpGestureRecognization()
        setUpTextViewDelegation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func didTapMemoItem(with memo: Memo) {
        updateUI(with: memo)
    }
}
extension ContentViewController {
    private func setUpContentView() {
        self.view.backgroundColor = .white
        view.addSubview(scrollView)
        
        contentView.addSubview(titleTextView)
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            titleTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        contentView.addSubview(bodyTextView)
        NSLayoutConstraint.activate([
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 5),
            bodyTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bodyTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        setUpViewPropertyConstraints()
    }
    
    private func setUpGestureRecognization() {
        let titleTapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        let bodyTapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        
        self.titleTextView.isUserInteractionEnabled = true
        self.bodyTextView.isUserInteractionEnabled = true
        
        self.titleTextView.addGestureRecognizer(titleTapGesture)
        self.bodyTextView.addGestureRecognizer(bodyTapGesture)
    }
    
    private func setUpTextViewDelegation() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
        
        textViewDidChange(titleTextView)
        textViewDidChange(bodyTextView)
    }
    
    private func setUpViewPropertyConstraints() {
        titleTextView.isScrollEnabled = false
        bodyTextView.isScrollEnabled = false
        
        titleTextView.isEditable = false
        bodyTextView.isEditable = false
        
        titleTextView.dataDetectorTypes = .all
        bodyTextView.dataDetectorTypes = .all
    }
    
    private func updateUI(with memo: Memo) {
        titleTextView.text = memo.title
        bodyTextView.text = memo.body
    }
}
extension ContentViewController: UIGestureRecognizerDelegate {
    @objc func keyboardWillShow(_ sender: Notification) {
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            bodyTextView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -150)
        ])
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            bodyTextView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
    @objc func textViewTapped(sender: UITapGestureRecognizer) {
        let sentTextView = sender.view as? UITextView
        if let textView = sentTextView {
            textView.isEditable = true
            textView.becomeFirstResponder()
        }
    }
}
extension ContentViewController: UITextViewDelegate {
    @objc private func didTapDoneButton(_ sender: Any) {
        self.titleTextView.endEditing(true)
        self.bodyTextView.endEditing(true)
    }
        
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.view.frame.width, height: .infinity)
        let rearrangedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = rearrangedSize.height
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
    }
}
