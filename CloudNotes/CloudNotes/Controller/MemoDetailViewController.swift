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
    private var currentIndexPath: IndexPath = .zero
    private var currentMemoId: UUID?
    private weak var delegate: MemoManageable?
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .largeTitle)
        textView.adjustsFontForContentSizeCategory = true
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
    
    func updateCurrentMemoId(with id: UUID?) {
        currentMemoId = id
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
            memoTextView.text = .blank
        } else {
            memoTextView.attributedText = convertToAttributedString(title: title, body: body)
        }
        
        memoTextView.contentOffset = .zero
    }
    
    func makeTextViewFirstResponder() {
        memoTextView.becomeFirstResponder()
    }
    
    private func convertToAttributedString(title: String, body: String) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        
        let titleAttributedText = NSAttributedString(string: title, attributes: TextAttribute.title)
        let spacing = NSAttributedString(string: .lineBreak, attributes: TextAttribute.body)
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
        let moreOptionButton = UIBarButtonItem(image: UIImage(systemName: SystemIcon.moreOption), style: .plain, target: self, action: nil)
        let shareAction = UIAction(title: ActionTitle.share, image: UIImage(systemName: SystemIcon.share)) { _ in
            self.delegate?.presentShareActivity(at: self.currentIndexPath)
        }
        let deleteAction = UIAction(title: ActionTitle.delete, image: UIImage(systemName: SystemIcon.trash), attributes: .destructive) { _ in
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
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.upload(at: currentIndexPath)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let (title, body) = textView.text.splitedText
        delegate?.update(at: currentIndexPath, title: title, body: body)
        currentIndexPath = .zero
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textAsNSString = textView.text as NSString
        let replacedString = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let titleRange = replacedString.range(of: .lineBreak)
        
        if titleRange.location > range.location {
            textView.typingAttributes = TextAttribute.title
        } else {
            textView.typingAttributes = TextAttribute.body
        }
        
        return true
    }
}
