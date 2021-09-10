//
//  MemoDatailViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoDetailViewController: UIViewController, TextSeparatable {
    // MARK: Property
    private let memoContentsTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.scrollsToTop = true
        textView.autocorrectionType = .no
        
        return textView
    }()
    
    private var currentMemo: CloudMemo?
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTextViewConstraint()
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
        memoContentsTextView.delegate = self
        congifureTextViewBackGroundColor()
    }
    
    func setupTextViewConstraint() {
        NSLayoutConstraint.activate([
            memoContentsTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoContentsTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoContentsTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoContentsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
    
    func configure(_ memo: CloudMemo?) {
        currentMemo = memo
        showMemo()
    }
    
    func showMemo() {
        if let title = currentMemo?.title, let body = currentMemo?.body {
            let appendedMemo = title + NameSpace.TextView.space + body
            memoContentsTextView.text = appendedMemo
        }
    }
}

// MARK: - Screen Transition Supports
extension MemoDetailViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        congifureTextViewBackGroundColor()
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let texts = separateText(memoContentsTextView.text)
        currentMemo?.title = texts.title
        currentMemo?.body = texts.body
    }
}
