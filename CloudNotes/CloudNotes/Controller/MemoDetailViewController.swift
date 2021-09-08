//
//  MemoDatailViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoDetailViewController: UIViewController {
    // MARK: Property
    private let memoContentsTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        configureView()
        configureMemoTextViewContentsConstraint()
    }
}

extension MemoDetailViewController {
    enum NameSpace {
        enum TextView {
            static let space = "\n"
            static let doubleSpace = space + space
        }
    }
}

// MARK: Setup Navigation
extension MemoDetailViewController {
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapButton))
    }
    
    @objc func didTapButton() {
        
    }
}

// MARK: Setup TextView And View
extension MemoDetailViewController {
    private func configureMemoTextViewContentsConstraint() {
        NSLayoutConstraint.activate([
            memoContentsTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoContentsTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoContentsTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoContentsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureView() {
        
        if UITraitCollection.current.horizontalSizeClass == .compact {
            memoContentsTextView.backgroundColor = .systemGray
        }
        
        view.backgroundColor = .white
        view.addSubview(memoContentsTextView)
    }
    
    func showContents(of memo: Memo) {
        let appendedText = memo.title + NameSpace.TextView.doubleSpace + memo.body
        memoContentsTextView.text = appendedText
        memoContentsTextView.layoutIfNeeded()
    }
}
