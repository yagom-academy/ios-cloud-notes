//
//  MemoDatailViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoDatailViewController: UIViewController {
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
        print("\(self) 제거되었음")
    }
}

// MARK: Setup Navigation
extension MemoDatailViewController {
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapButton))
    }
    
    @objc func didTapButton() {
        
    }
}

// MARK: Setup TextView And View
extension MemoDatailViewController {
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
        memoContentsTextView.text.append(memo.title)
        memoContentsTextView.text.append("\n\n")
        memoContentsTextView.text.append(memo.body)
    }
}
