//
//  TextViewController.swift
//  CloudNotes
//
//  Created by steven on 2021/05/31.
//

import UIKit

class TextViewController: UIViewController {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .title1)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        addNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.contentOffset = .zero
        print("viewwillappear")
    }
    
    override func viewWillLayoutSubviews() {
        print(UITraitCollection.current.horizontalSizeClass.rawValue)
        print(UITraitCollection.current.verticalSizeClass.rawValue)
        print("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
    }
    
    func changedTextBySelectedCell(with memo: Memo) {
        if let title = memo.title,
           let body = memo.body {
            textView.text = title + "\n"
            textView.text.append(body)
        } else {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }

}

// MARK: 키보드 처리
extension TextViewController {
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
        textView.contentInset = contentInset
        textView.verticalScrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        textView.contentInset = contentInset
        textView.verticalScrollIndicatorInsets = contentInset
    }
    
}

extension TextViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let listViewController = splitViewController?.viewControllers.first?.children.first as? ListTableViewController {
            listViewController.changeSelectedCellLabelValue()
        }
    }
}
