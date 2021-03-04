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
    private var memo: Memo?
    private var isDeleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(memoTextView)
        memoTextView.delegate = self
        configureConstraints()
        registerKeyboardNotifications()
        configureGesture()
        setupNavigationItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exitEditMode()
        memo = nil
        memoTextView.text = nil
    }
    
    func saveMemo() {
        if isDeleted {
            return
        }
        
        var title: String = ""
        var body: String = ""
        let date: Int = Int(Date().timeIntervalSince1970)
        
        if let firstIndex =
            memoTextView.text.firstIndex(of: "\n") {
            title = String(memoTextView.text[memoTextView.text.startIndex..<firstIndex])
            let nextIndex = memoTextView.text.index(after: firstIndex)
            body = String(memoTextView.text[nextIndex..<memoTextView.text.endIndex])
        } else {
            title = memoTextView.text
        }
        
        if let memo = self.memo {
            do {
                try Memo.update(memo: memo, title, body, date)
            } catch {
                showErrorAlert(viewController: self, message: "메모를 업데이트하지 못했어요!")
            }
        } else {
            do {
                try Memo.create(title, body, date)
            } catch {
                showErrorAlert(viewController: self, message: "메모를 생성하지 못했어요!")
            }
        }
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
        saveMemo()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(touchUpMoreBarButton))
    }
    
    @objc func touchUpMoreBarButton() {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share...", style: .default, handler: share(_:))
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: delete(_:))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        menu.addAction(shareAction)
        menu.addAction(deleteAction)
        menu.addAction(cancelAction)
        
        present(menu, animated: true, completion: nil)
    }
    
    func share(_ alertAction: UIAlertAction) {
        guard let memoText = memoTextView.text else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [memoText], applicationActivities: [])
        present(activityViewController, animated: true, completion: nil)
    }
    
    func delete(_ alertAction: UIAlertAction) {
        if let memo = self.memo {
            do {
                try Memo.delete(memo: memo)
                self.memo = nil
                isDeleted = true
                if let memoSplitViewController = self.splitViewController as? MemoSplitViewController {
                    memoSplitViewController.popMemoViewController()
                }
            } catch {
                
            }
        }
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
    
    func setMemo(_ memo: Memo?) {
        if let memo = memo {
            self.memo = memo
            memoTextView.text = (memo.title ?? "") + "\n" + (memo.body ?? "")
        } else {
            memoTextView.text = nil
        }
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
