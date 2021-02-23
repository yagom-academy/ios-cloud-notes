//
//  ContentViewController.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class ContentViewController: UIViewController {
    let doneText = "완료"
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: MemoTextView = {
        let contentView = MemoTextView()
        contentView.delegate = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.isScrollEnabled = false
        contentView.isSelectable = true
        contentView.isEditable = false
        contentView.autocorrectionType = .no
        contentView.isUserInteractionEnabled = true
        contentView.dataDetectorTypes = .all
        return contentView
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: doneText, style: .done, target: self, action: #selector(didTapDoneButton(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = doneButton
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
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    private func updateUI(with memo: Memo) {
        let headLinefont = UIFont.boldSystemFont(ofSize: 24)
        let bodyLinefont = UIFont.systemFont(ofSize: 15)
        let memoAttributedString = NSMutableAttributedString(string: memo.title)
        let bodyAttributedString = NSMutableAttributedString(string: "\n\(memo.body)")
        memoAttributedString.addAttribute(.font, value: headLinefont, range: NSRange(location: 0, length: memo.title.count))
        bodyAttributedString.addAttribute(.font, value: bodyLinefont, range: NSRange(location: 0, length: memo.body.count))
        memoAttributedString.append(bodyAttributedString)
        contentView.attributedText = memoAttributedString
        textViewDidChange(contentView)
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
    
    @objc private func didTapDoneButton(_ sender: Any) {
        contentView.endEditing(true)
        contentView.isEditable = false
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
        
        let heightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.isActive = true
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
