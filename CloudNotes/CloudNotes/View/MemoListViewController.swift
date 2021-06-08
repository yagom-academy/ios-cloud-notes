//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

class MemoListViewController: UIViewController {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewMemo))
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

    @objc private func createNewMemo() {
        MemoManager.shared.createMemo()
    }
}

// MARK: - UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let memos = MemoManager.shared.memos else { return 0 }

        return memos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoPreviewCell.reusableIdentifier) as? MemoPreviewCell,
              let memos = MemoManager.shared.memos else { return UITableViewCell() }
        cell.fetchData(memo: memos[indexPath.row])

        return cell
    }
}

// MARK: - UITableViewDelegate

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        splitViewDelegate?.didSelectRow(indexPath: indexPath, memoListViewDelegate: self)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
            MemoManager.shared.deleteMemo(indexPath: indexPath)
        }
        let shareAction = UIContextualAction(style: .normal, title: "share") { _, _, _ in
            guard let cellToShare = self.memoListTableView.cellForRow(at: indexPath) else { return }
            self.splitViewDelegate?.showActivityView(indexPath: indexPath, sourceView: cellToShare)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: - MemoListViewDelegate

extension MemoListViewController: MemoListViewDelegate {
    func createNewCell() {
        let topIndexPath = IndexPath(row: 0, section: 0)
        memoListTableView.insertRows(at: [topIndexPath], with: .automatic)
        memoListTableView.selectRow(at: topIndexPath, animated: true, scrollPosition: .top)
    }

    func updateCell(indexPath: IndexPath) {
        memoListTableView.reloadRows(at: [indexPath], with: .none)
    }

    func deleteCell(indexPath: IndexPath) {
        memoListTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
