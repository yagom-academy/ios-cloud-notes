//
//  MemoDetailView.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/02.
//

import UIKit

class MemoDetailView: RootView {
    lazy var detailTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.systemGray4
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.allowsEditingTextAttributes = true
        return textView
    }()

    override func setup() {
        super.setup()
        addSubviews(detailTextView)
    }

    override func setupUI() {
        super.setupUI()
        NSLayoutConstraint.activate([
                    detailTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    detailTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    detailTextView.topAnchor.constraint(equalTo: self.topAnchor),
                    detailTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
