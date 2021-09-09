//
//  MemoListView.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/02.
//

import UIKit

class MemoListView: UIView, RootViewable {
    lazy var memoTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubviews(memoTableView)
    }

    func setupUI() {
        self.backgroundColor = .clear
        NSLayoutConstraint.activate([
            memoTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            memoTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            memoTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            memoTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
