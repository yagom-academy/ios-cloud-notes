//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class ContentViewController: UIViewController {
    private let headLinefont = UIFont.boldSystemFont(ofSize: 24)
    private let bodyLinefont = UIFont.systemFont(ofSize: 15)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    private lazy var contentView: MemoTextView = {
        let contentView = MemoTextView()
        contentView.delegate = self
        contentView.backgroundColor = .white
        contentView.isScrollEnabled = false
        contentView.isEditable = false
        contentView.autocorrectionType = .no
        contentView.isUserInteractionEnabled = true
        contentView.dataDetectorTypes = .all
        return contentView
    }()
    
    private lazy var optionButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapOptionButton(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = optionButton
        setUpConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func didTapMemoItem(with memo: Memo) {
        updateUI(with: memo)
    }
}

extension ContentViewController {
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func updateUI(with memo: Memo) {
//        let memoAttributedString = NSMutableAttributedString(string: memo.title)
//        let bodyAttributedString = NSMutableAttributedString(string: "\n\(memo.body)")
//        memoAttributedString.addAttribute(.font, value: headLinefont, range: NSRange(location: 0, length: memo.title.count))
//        bodyAttributedString.addAttribute(.font, value: bodyLinefont, range: NSRange(location: 0, length: memo.body.count))
//        memoAttributedString.append(bodyAttributedString)
//        contentView.attributedText = memoAttributedString
        updateTextViewSize()
    }
    
    private func updateTextViewSize() {
        let size = CGSize(width: self.view.frame.width, height: .infinity)
        let rearrangedSize = contentView.sizeThatFits(size)
        
        contentView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = rearrangedSize.height
            }
        }
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        scrollView.contentInset.bottom = keyboardFrame.size.height
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func didTapOptionButton(_ sender: UIBarButtonItem) {
        contentView.endEditing(true)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share...", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            print("공유 관련 액션 수행")
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            let alertController = UIAlertController(title: "진짜요?", message: "진짜로 삭제하시겠습니까?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (alert: UIAlertAction!) -> Void in
                print("삭제관련액션수행")
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewSize()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let headerAttributes: [NSAttributedString.Key: UIFont] = [.font: .boldSystemFont(ofSize: 24)]
        let bodyAttributes: [NSAttributedString.Key: UIFont] = [.font : .systemFont(ofSize: 15)]
        let textAsNSString: NSString = contentView.text as NSString
        let replaced: NSString = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let boldRange: NSRange = replaced.range(of: "\n")
        
        if boldRange.location <= range.location {
            contentView.typingAttributes = bodyAttributes
        } else {
            contentView.typingAttributes = headerAttributes
        }
        
        return true
    }
}
