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
        
        memoTextView.text = "\(memoTitle)\n\n\(memoBody)"
        updateTextFontStyle()
        updateLayout()
    }
    
    private func updateTextFontStyle() {
        let textViewTitleFontSize = 24
        let textViewBodyFontSize = 20
        
        let titleFont = UIFont.boldSystemFont(ofSize: CGFloat(textViewTitleFontSize))
        let bodyFont = UIFont.systemFont(ofSize: CGFloat(textViewBodyFontSize))
        
        let attributedStr = NSMutableAttributedString(string: memoTextView.text)
        attributedStr.addAttribute (.font, value: titleFont, range: (memoTextView.text as NSString).range(of: memoTitle))
        attributedStr.addAttribute(.font, value: bodyFont, range: (memoTextView.text as NSString).range(of: memoBody))
        
        memoTextView.attributedText = attributedStr
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
            constant: CGFloat(commonTextViewInset*(-1))
        ).isActive = true
        
        view.backgroundColor = .white
        
        let item = memoTextView.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
    }
}
