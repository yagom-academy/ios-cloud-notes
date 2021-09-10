//
//  ComposeMemoViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import UIKit

class ComposeMemoViewController: UIViewController, TextViewConstraintProtocol {
    // MARK: Property
    let composeMemoTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no
        textView.becomeFirstResponder()
        
        return textView
    }()
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTextViewConstraintFullScreen(composeMemoTextView, superView: view)
    }
}

// MARK: Setup TextView And View
extension ComposeMemoViewController {
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(composeMemoTextView)
    }
}

extension ComposeMemoViewController {
    
    private func setupNavigationItem() {
        setupRightBarButtonItem()
        setupLeftBarButtonItem()
    }
    
    private func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.generateBarButtonItem(barButtonSystemItem: .save)
    }
    
    private func setupLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.generateBarButtonItem(barButtonSystemItem: .cancel)
    }
    
    @objc func didTapButton() {
        
    }
    
}
