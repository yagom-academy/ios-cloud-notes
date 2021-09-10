//
//  TextViewContraintable.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import UIKit

protocol TextViewContraintable {
    func setupTextViewFullScreen(_ textView: UITextView, superView: UIView)
}

extension TextViewContraintable {
    func setupTextViewFullScreen(_ textView: UITextView, superView: UIView) {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
