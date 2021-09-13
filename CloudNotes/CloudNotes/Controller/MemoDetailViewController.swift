//
//  MemoDatailViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoDetailViewController: UIViewController, TextSeparatable, TextViewContraintable {
    // MARK: Property
    weak var delegate: MemoDetailViewControllerDelegate?
    private var indexPath: IndexPath?
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
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTextViewFullScreen(memoContentsTextView, superView: view)
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
                                                            action: #selector(didTapSeeMoreButton))
    }
    
    @objc func didTapSeeMoreButton() {
        delegate?.didTapSeeMoreButton()
    }
}

// MARK: Setup TextView And View
extension MemoDetailViewController {
    private func configureMemoTextView() {
        memoContentsTextView.delegate = self
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
    
    func configureMemoContents(title: String?, body: String?, lastModifier: Date?, indexPath: IndexPath) {
        if let title = title, let body = body {
            let appendedMemo = title + NameSpace.TextView.space + body
            memoContentsTextView.text = appendedMemo
        }
        self.indexPath = indexPath
    }
}

// MARK: - Screen Transition Supports
extension MemoDetailViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        congifureTextViewBackGroundColor()
    }
}

// MARK: - Delegate
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let texts = separateText(memoContentsTextView.text)
        delegate?.contentsDidChanged(at: indexPath ?? IndexPath(),
                                     contetnsText: texts)
    }
}
