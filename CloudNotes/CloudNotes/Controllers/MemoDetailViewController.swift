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

        updateLayout()
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
            constant: CGFloat(commonTextViewInset)
        ).isActive = true
        memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        view.backgroundColor = .white
    }
}
