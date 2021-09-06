//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
    let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(textView)
        configureTextView()
        setLayoutForTextView()
    }
    
    private func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no
        textView.backgroundColor = .secondarySystemBackground
        textView.textColor = .secondaryLabel
    }
    
    private func setLayoutForTextView() {
        NSLayoutConstraint.activate([textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     textView.topAnchor.constraint(equalTo: view.topAnchor),
                                     textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
