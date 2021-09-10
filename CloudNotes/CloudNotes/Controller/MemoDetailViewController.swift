//
//  MemoDatailViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoDetailViewController: UIViewController, TextViewConstraintProtocol {
    // MARK: Property
    private let memoContentsTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.scrollsToTop = true

        return textView
    }()
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTextViewConstraintFullScreen(memoContentsTextView, superView: view)
        configureMemoTextView()
    }
}

extension MemoDetailViewController {
    enum NameSpace {
        enum TextView {
            static let space = "\n"
            static let doubleSpace = space + space
            static let zeroContentRange = NSRange(location: 0, length: 0)
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
    private func configureMemoTextView() {
        congifureTextViewBackGroundColor()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(memoContentsTextView)
    }
    
    private func congifureTextViewBackGroundColor() {
        if UITraitCollection.current.horizontalSizeClass == .compact {
            memoContentsTextView.backgroundColor = .systemGray
        } else {
            memoContentsTextView.backgroundColor = .white
        }
    }
    
    func showContents(of memo: Memo) {
        let appendedText = memo.title + NameSpace.TextView.doubleSpace + memo.body
        memoContentsTextView.text = appendedText
    }
}

extension MemoDetailViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        congifureTextViewBackGroundColor()
    }
}
