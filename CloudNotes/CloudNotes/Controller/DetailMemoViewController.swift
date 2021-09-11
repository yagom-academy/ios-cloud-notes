//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/01.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    weak var delegate: DetailMemoDelegate?
    var index = IndexPath()

    var memo: Memo? {
        didSet {
            updateMemo()
        }
    }
    
    private var titleTextView: UITextView = {
        let titleTextView = UITextView()
        titleTextView.font = UIFont.preferredFont(forTextStyle: .title2)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.isScrollEnabled = false
        return titleTextView
    }()
    
    private var bodyTextView: UITextView = {
        let bodyTextView = UITextView()
        bodyTextView.font = UIFont.systemFont(ofSize: 20)
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        return bodyTextView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        bodyTextView.delegate = self
        view.backgroundColor = .white
        addSubView()
        updateMemo()
        configureAutoLayout()
        configureNavigationItem()
        //registerNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShown(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        
        bodyTextView.contentInset = contentInset
        bodyTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        bodyTextView.contentInset = contentInset
        bodyTextView.scrollIndicatorInsets = contentInset
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func updateMemo() {
        titleTextView.text = memo?.title
        bodyTextView.text = memo?.body
    }
    
    private func addSubView() {
        view.addSubview(titleTextView)
        view.addSubview(bodyTextView)
    }
    
    private func configureAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            bodyTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant:
            margin),
            bodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin)
        ])
    }
}

extension DetailMemoViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let newMemo = Memo(title: titleTextView.text, body: bodyTextView.text, date: Date().timeIntervalSince1970)
        
        memo = newMemo
        
        guard let savedMemo = memo else { return }
        delegate?.saveMemo(with: savedMemo, index: self.index)
    }
}
