//
//  MemoFormViewController.swift
//  CloudNotes
//
//  Created by TORI on 2021/06/01.
//

import UIKit

class MemoFormViewController: UIViewController {
    
    let MemoTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setMemoTextView()
        MemoTextView.contentOffset = .zero
    }
    
    private func setMemoTextView() {
        MemoTextView.backgroundColor = .systemGray
        MemoTextView.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(MemoTextView)
        MemoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let memoTextViewConstraints = ([
            MemoTextView.topAnchor.constraint(equalTo: view.topAnchor),
            MemoTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            MemoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            MemoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate(memoTextViewConstraints)
    }
}
