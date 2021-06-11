//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

class MemoListViewController: UIViewController {
    weak var memoListViewDelegate: MemoListViewDelegate?

    private let memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MemoPreviewCell.self, forCellReuseIdentifier: MemoPreviewCell.reusableIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
    }

    func reloadMemoListTableViewData() {
        memoListTableView.reloadData()
    }

    private func setUpView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "메모"

        let memoAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpMemoAddButton))
        navigationItem.rightBarButtonItem = memoAddButton
    }

    private func setUpTableView() {
        view.addSubview(memoListTableView)

        memoListTableView.dataSource = self
        memoListTableView.delegate = self

        NSLayoutConstraint.activate([
            memoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func touchUpMemoAddButton() {
        memoListViewDelegate?.memoAddButtonDidTapped()
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
        memoListViewDelegate?.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
            self.memoListViewDelegate?.memoDeleteButtonDidTapped(memoIndexPath: indexPath)
        }
        let shareAction = UIContextualAction(style: .normal, title: "share") { _, _, _ in
            guard let cellToShare = self.memoListTableView.cellForRow(at: indexPath) else { return }
            self.memoListViewDelegate?.memoShareButtonDidTapped(memoIndexPathToShare: indexPath, sourceView: cellToShare)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: - Cell Management

extension MemoListViewController {
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
