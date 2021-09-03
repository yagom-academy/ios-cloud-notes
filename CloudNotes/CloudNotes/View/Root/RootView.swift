//
//  RootView.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/02.
//

import UIKit

class RootView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setup() { }
    func setupUI() {
        backgroundColor = .clear
    }
}
