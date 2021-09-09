//
//  MemoDetailView.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/02.
//

import UIKit

class MemoDetailView: UIView, RootViewable {
    lazy var detailTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.backgroundColor = UIColor.systemGray4
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.allowsEditingTextAttributes = false

        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setup() {
        addSubviews(detailTextView)
    }

    func setupUI() {
        NSLayoutConstraint.activate([
                    detailTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    detailTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    detailTextView.topAnchor.constraint(equalTo: self.topAnchor),
                    detailTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
