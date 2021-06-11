//
//  UITextViewExtension.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/07.
//

import UIKit

class MemoTextView: UITextView {
    init(font: UIFont) {
        super.init(frame: .zero, textContainer: nil)
        self.font = font
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
