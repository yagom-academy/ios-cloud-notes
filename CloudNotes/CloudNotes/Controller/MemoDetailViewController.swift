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
        memoContentsTextView.contentOffset = CGPoint(x: 0, y: 0)
        setupNavigationItem()
        configureView()
        configureMemoTextViewContentsConstraint()
    }
    
    deinit {
        debugPrint("\(self) 제거됨")
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
        memoContentsTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        memoContentsTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        memoContentsTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        memoContentsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
    }
}
