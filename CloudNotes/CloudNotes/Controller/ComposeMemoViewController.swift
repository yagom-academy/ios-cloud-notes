//
//  ComposeMemoViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import UIKit

class ComposeMemoViewController: UIViewController {
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
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureMemoTextViewContentsConstraint()
    }
}

// MARK: Setup TextView And View
extension ComposeMemoViewController {
    private func configureMemoTextViewContentsConstraint() {
        NSLayoutConstraint.activate([
            composeMemoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            composeMemoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            composeMemoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            composeMemoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(composeMemoTextView)
    }
}
