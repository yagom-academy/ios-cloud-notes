//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoDetailViewController: UIViewController {
    private let memoDeatailTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(memoDeatailTextView)
        configureTextView()
        setLayoutForTextView()
    }
    
    private func configureTextView() {
        memoDeatailTextView.translatesAutoresizingMaskIntoConstraints = false
        memoDeatailTextView.autocorrectionType = .no
        memoDeatailTextView.backgroundColor = .secondarySystemBackground
        memoDeatailTextView.textColor = .secondaryLabel
    }
    
    private func setLayoutForTextView() {
        NSLayoutConstraint.activate([memoDeatailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     memoDeatailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     memoDeatailTextView.topAnchor.constraint(equalTo: view.topAnchor),
                                     memoDeatailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
