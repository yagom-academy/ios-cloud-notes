//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

private enum TextAttribute {
    static let title = [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle),
        NSAttributedString.Key.foregroundColor: UIColor.label
    ]
    
    static let body = [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2),
        NSAttributedString.Key.foregroundColor: UIColor.label
    ]
}

class MemoDetailViewController: UIViewController {
    private var currentIndexPath = IndexPath(row: 0, section: 0)
    private var currentText: String?
    private weak var delegate: MemoManageable?
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .largeTitle)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTextView.delegate = self
        configureUI()
        addKeyboardNotificationObserver()
    }
    
    init(delegate: MemoManageable) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateCurrentIndexPath(with indexPath: IndexPath) {
        currentIndexPath = indexPath
    }
    
    func updateMemo(title: String?, body: String?) {
        memoTextView.resignFirstResponder()
        
        guard let title = title,
              let body = body else {
            return
        }
        
        if title.isEmpty && body.isEmpty {
            memoTextView.text = ""
        } else {
            memoTextView.attributedText = convertToAttributedString(title: title, body: body)
        }
        
        memoTextView.contentOffset = .zero
    }
    
    private func convertToAttributedString(title: String, body: String) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        
        let titleAttributedText = NSAttributedString(string: title, attributes: TextAttribute.title)
        let spacing = NSAttributedString(string: "\n", attributes: TextAttribute.body)
        let bodyAttributedText = NSAttributedString(string: body, attributes: TextAttribute.body)
        
        mutableAttributedString.append(titleAttributedText)
        mutableAttributedString.append(spacing)
        mutableAttributedString.append(bodyAttributedText)
        
        return mutableAttributedString
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureTextView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let moreOptionButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        let shareAction = UIAction(title: "공유", image: UIImage(systemName: "square.and.arrow.up.fill")) { _ in
            self.delegate?.presentShareActivity(at: self.currentIndexPath)
        }
        let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { _ in
            self.delegate?.presentDeleteAlert(at: self.currentIndexPath)
        }
        let optionMenu = UIMenu(options: .displayInline, children: [shareAction, deleteAction])
        moreOptionButton.menu = optionMenu
        self.navigationItem.rightBarButtonItem = moreOptionButton
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
    
    func splitText(text: String) -> (title: String, body: String) {
        let splitedText = text.split(separator: "\n", maxSplits: 1).map { String($0) }
        
        if splitedText.count == 1 {
            return (splitedText[0], "")
        } else if splitedText.count == 2 {
            return (splitedText[0], splitedText[1])
        } else {
            return ("", "")
        }
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.hasText else {
            delegate?.delete(at: currentIndexPath)
            return
        }
        
        guard currentText != textView.text else {
            return
        }
        
        let (title, body) = splitText(text: textView.text)
        delegate?.update(at: currentIndexPath, title: title, body: body)
        
        currentIndexPath = IndexPath(row: 0, section: 0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        currentText = textView.text
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let (title, body) = splitText(text: textView.text)
        delegate?.reloadRow(at: currentIndexPath, title: title, body: body)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textAsNSString = textView.text as NSString
        let replacedString = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let titleRange = replacedString.range(of: "\n")
        
        if titleRange.location > range.location {
            textView.typingAttributes = TextAttribute.title
        } else {
            textView.typingAttributes = TextAttribute.body
        }
        
        return true
    }
}
