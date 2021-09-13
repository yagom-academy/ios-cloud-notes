//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private let memoTitle: String
    private let memoBody: String
    private let titleSeperator = "\n"
    
    private let memoTextView = UITextView()
    
    init(memo: Memo) {
        self.memoTitle = memo.title
        self.memoBody = memo.body
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.text = "\(memoTitle)\(titleSeperator)\(memoBody)"
        updateTextFontStyle()
        updateLayout()
        initTextViewScrollToTop()
        clearBarButtonGroupsForInputAssistantItem()
    }
    
    private func initTextViewScrollToTop() {
        let contentHeight = memoTextView.contentSize.height
        memoTextView.contentOffset = CGPoint(x: 0, y: -contentHeight)
    }
    
    private func updateTextFontStyle() {
        let textViewTitleFontSize = 24
        let textViewBodyFontSize = 20
        
        let titleFont = UIFont.boldSystemFont(ofSize: CGFloat(textViewTitleFontSize))
        let bodyFont = UIFont.systemFont(ofSize: CGFloat(textViewBodyFontSize))
        
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
        let bodyAttributes: [NSAttributedString.Key: Any] = [.font: bodyFont]
        
        let titleAttributedText = NSMutableAttributedString(string: "\(memoTitle)\(titleSeperator)", attributes: titleAttributes)
        let bodyAttributedText = NSAttributedString(string: memoBody, attributes: bodyAttributes)
        
        titleAttributedText.append(bodyAttributedText)
        
        memoTextView.attributedText = titleAttributedText
    }
    
    private func updateLayout() {
        let commonTextViewInset = 20
        
        view.addSubview(memoTextView)
        
        let safeArea = view.safeAreaLayoutGuide
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        memoTextView.topAnchor.constraint(
            equalTo: safeArea.topAnchor,
            constant: CGFloat(commonTextViewInset)
        ).isActive = true
        memoTextView.leadingAnchor.constraint(
            equalTo: safeArea.leadingAnchor,
            constant: CGFloat(commonTextViewInset)
        ).isActive = true
        memoTextView.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor,
            constant: 0
        ).isActive = true
        memoTextView.trailingAnchor.constraint(
            equalTo: safeArea.trailingAnchor,
            constant: CGFloat(-commonTextViewInset)
        ).isActive = true
        
        view.backgroundColor = .white
    }
    
    private func clearBarButtonGroupsForInputAssistantItem() {
        let item = memoTextView.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
    }
}
