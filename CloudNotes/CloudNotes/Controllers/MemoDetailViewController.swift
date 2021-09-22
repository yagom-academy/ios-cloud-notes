//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
    enum MemoStatus {
        case guide
        case add
        case edit
        case willDelete
    }
    
    weak var listViewControllerDelegate: PrimaryViewControllerDelegate?
    
    private var memoTitle: String
    private var memoBody: String
    private var titleSeperator: String {
        return memoBody.isEmpty ? "" : "\n"
    }
    private var hasBodyText: Bool {
        return memoBody.isNotEmpty
    }
    private var status: MemoStatus
    private let memoEntity: MemoEntity?
    
    private let memoTextView = UITextView()
    
    init(isEditable: Bool = true) {
        self.memoTitle = isEditable ? "" : "새 매모를 추가해주세요."
        self.memoBody = ""
        self.status = isEditable ? .add : .guide
        memoEntity = nil
        memoTextView.isEditable = isEditable
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(memo: MemoEntity) {
        self.memoTitle = memo.title
        self.memoBody = memo.body
        self.status = .edit
        memoEntity = memo

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
        
        memoTextView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let title = memoTitle.trim
        let body = memoBody.trim
        
        switch status {
        case .guide, .willDelete: return
        case .add:
            if title.isEmpty && body.isEmpty {
                return
            }
            if body.isEmpty {
                memoBody = "추가 텍스트 없음"
            }
            PersistenceManager.shared.createMemo(title: memoTitle, body: memoBody)
            listViewControllerDelegate?.fetchEntityList()
        case .edit:
            guard let memoEntity = memoEntity else { return }
            if title.isEmpty && body.isEmpty {
                PersistenceManager.shared.deleteMemo(entity: memoEntity)
                listViewControllerDelegate?.fetchEntityList()
                return
            }
            if body.isEmpty {
                memoBody = "추가 텍스트 없음"
            }
            PersistenceManager.shared.updateMemo(entity: memoEntity,
                                                 title: memoTitle,
                                                 body: memoBody)
            listViewControllerDelegate?.fetchEntityList()
        }
    }
    
    func isCurrentEntity(_ targetEntity: MemoEntity) -> Bool {
        guard let sourceEntity = memoEntity else {
            return false
        }
        
        return targetEntity == sourceEntity
    }
    
    func updateStatusToWillDelete() {
        status = .willDelete
    }
    
    private func initTextViewScrollToTop() {
        let contentHeight = memoTextView.contentSize.height
        memoTextView.contentOffset = CGPoint(x: 0, y: -contentHeight)
    }
    
    private func updateTitleFontStyle() -> NSMutableAttributedString {
        let textViewTitleFontSize = 24
        let titleFont = UIFont.boldSystemFont(ofSize: CGFloat(textViewTitleFontSize))
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
        
        return NSMutableAttributedString(string: "\(memoTitle)\(titleSeperator)", attributes: titleAttributes)
    }
    
    private func updateBodyFontStyle() -> NSAttributedString {
        let textViewBodyFontSize = 20
        let bodyFont = UIFont.systemFont(ofSize: CGFloat(textViewBodyFontSize))
        let bodyAttributes: [NSAttributedString.Key: Any] = [.font: bodyFont]
        
        return NSAttributedString(string: memoBody, attributes: bodyAttributes)
    }
    
    private func updateTextFontStyle() {
        let titleAttributedText = updateTitleFontStyle()
        
        if hasBodyText {
            let bodyAttributedText = updateBodyFontStyle()
            titleAttributedText.append(bodyAttributedText)
        }
        
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

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let splittedText = text.split(separator: "\n", maxSplits: 1)
            memoTitle = String(splittedText.first ?? "")
            if splittedText.count > 1 {
                memoBody = String(splittedText.last ?? "")
            } else {
                memoBody = text.contains(Character("\n")) ? "\n" : ""
            }
            
            if let textRange = textView.selectedTextRange {
                memoTextView.isScrollEnabled = false
                updateTextFontStyle()
                textView.selectedTextRange = textView.textRange(from: textRange.start, to: textRange.start)
                memoTextView.isScrollEnabled = true
            }
        }
    }
}
