//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class ContentViewController: UIViewController, UIGestureRecognizerDelegate {
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpContentView()
    }
    
    private func setUpContentView() {
        self.navigationItem.rightBarButtonItem = doneButton
        
        let titleTapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        let bodyTapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        
        self.titleTextView.isUserInteractionEnabled = true
        self.bodyTextView.isUserInteractionEnabled = true
        
        self.titleTextView.addGestureRecognizer(titleTapGesture)
        self.bodyTextView.addGestureRecognizer(bodyTapGesture)
        
        self.view.backgroundColor = .white
        self.view.addSubview(titleTextView)
        self.view.addSubview(bodyTextView)
        
        titleTextView.delegate = self
        bodyTextView.delegate = self
        
        setUpConstraints()
        
        textViewDidChange(titleTextView)
        textViewDidChange(bodyTextView)
    }
    
    private func setUpConstraints() {
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: 5),
            titleTextView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            titleTextView.heightAnchor.constraint(equalToConstant: 50),
            
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20),
            bodyTextView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            bodyTextView.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>)
//            bodyTextView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
        
        titleTextView.isScrollEnabled = true
        bodyTextView.isScrollEnabled = true
        
        titleTextView.isEditable = false
        bodyTextView.isEditable = false
        
        titleTextView.dataDetectorTypes = .all
        bodyTextView.dataDetectorTypes = .all
    }
    
    private func updateUI(with memo: Memo) {
        titleTextView.text = memo.title
        bodyTextView.text = memo.body
    }
    
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
    
    @objc private func didTapDoneButton(_ sender: Any) {
        self.titleTextView.endEditing(true)
        self.bodyTextView.endEditing(true)
    }
}
extension ContentViewController: ListViewControllerDelegate {
    func didTapMemoItem(with memo: Memo) {
        updateUI(with: memo)
    }
}
extension ContentViewController: UITextViewDelegate {
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
