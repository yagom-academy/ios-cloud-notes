//
//  MemoDatailViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoDatailViewController: UIViewController {
    
    private let memoContentsTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
    
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoContentsTextView.contentOffset = CGPoint(x: 0, y: 0)
        setupNavigationItem()
        configureView()
        configureMemoTextViewContentsConstraint()
    }
}

extension MemoDatailViewController {
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapButton))
    }
    
    @objc func didTapButton() {
        
    }
}

extension MemoDatailViewController {
    func configureMemoTextViewContentsConstraint() {
        memoContentsTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        memoContentsTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        memoContentsTextView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        memoContentsTextView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(memoContentsTextView)
    }
    
    func showContents(of memo: Memo) {
        memoContentsTextView.text = memo.body
    }
}
