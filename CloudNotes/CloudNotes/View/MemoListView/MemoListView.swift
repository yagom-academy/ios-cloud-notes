//
//  MemoListView.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/02.
//

import UIKit

class MemoListView: RootView {

    lazy var memoTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func setup() {
        super.setup()
        memoTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(memoTableView)
    }

    override func setupUI() {
        super.setupUI()
        NSLayoutConstraint.activate([
            memoTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            memoTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            memoTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            memoTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
