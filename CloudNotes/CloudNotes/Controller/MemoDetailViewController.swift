//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private var currentIndexPath: IndexPath?
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .title2)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addKeyboardNotificationObserver()
    }
    
    func updateCurrentIndexPath(with indexPath: IndexPath) {
        currentIndexPath = indexPath
    }
    
    func updateMemo(text: String?) {
        memoTextView.resignFirstResponder()
        memoTextView.text = text
        memoTextView.contentOffset = .zero
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureTextView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
    }
    
    @objc private func requestDeleteMemo() {
        guard let memoSplitViewController = self.splitViewController as? MemoSplitViewController else {
            return
        }
        
        guard let currentIndexPath = currentIndexPath else {
            return
        }
        
        memoSplitViewController.deleteMemo(at: currentIndexPath)
    }
    
    private func configureTextView() {
        view.addSubview(memoTextView)
        
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            memoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            memoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addKeyboardNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo as NSDictionary? else {
            return
        }
        
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        memoTextView.contentInset.bottom = keyboardHeight
        memoTextView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide() {
        memoTextView.contentInset.bottom = .zero
        memoTextView.verticalScrollIndicatorInsets.bottom = .zero
    }
}
