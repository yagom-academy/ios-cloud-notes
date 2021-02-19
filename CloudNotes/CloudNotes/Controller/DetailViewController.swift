//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/19.
//

import UIKit

class DetailViewController: UIViewController {
    private var memoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .blue
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setAutoLayout()
    }

    private func setAutoLayout() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: guide.topAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
}
