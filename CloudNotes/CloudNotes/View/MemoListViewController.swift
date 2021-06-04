//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

class MemoListViewController: UIViewController {
    private var memos: [Memo]?
    private weak var splitViewDelegate: SplitViewDelegate?

    private let memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(splitViewDelegate: SplitViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.splitViewDelegate = splitViewDelegate
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureView()
        configureTableView()
        addSubviews()
    }

    override func viewWillLayoutSubviews() {
        addConstraints()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }

    private func fetchData() {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        do {
            memos = try context?.fetch(Memo.fetchRequest())
        } catch {
            return
        }
    }

    private func configureTableView() {
        memoListTableView.dataSource = self
        memoListTableView.delegate = self
        memoListTableView.register(MemoPreviewCell.self, forCellReuseIdentifier: MemoPreviewCell.reusableIdentifier)
        memoListTableView.backgroundColor = .systemBackground
    }

    private func addSubviews() {
        view.addSubview(memoListTableView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            memoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let memos = memos else { return 0 }

        return memos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoPreviewCell.reusableIdentifier) as? MemoPreviewCell,
              let memos = memos else { return UITableViewCell() }
        cell.fetchData(memo: memos[indexPath.row])

        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memos = memos else { return }
        splitViewDelegate?.didSelectRow(memo: memos[indexPath.row], indexPath: indexPath, memoListViewDelegate: self)
    }
}

extension MemoListViewController: MemoListViewDelegate {
    func updateCell(indexPath: IndexPath) {
        memoListTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
