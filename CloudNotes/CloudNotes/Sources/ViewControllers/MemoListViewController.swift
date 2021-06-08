//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/02.
//

import UIKit

final class MemoListViewController: UIViewController {

    // MARK: Property

    private var memos = [Memo]() {
        didSet {
            memos.sort { $0.lastModified > $1.lastModified }
        }
    }

    // MARK: UI

    private lazy var memoAddButton = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: memoAddAction), menu: nil)

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MemoCell.self, forCellReuseIdentifier: "memoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "메모"
        navigationItem.setRightBarButton(memoAddButton, animated: true)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        memos = JSONDecoder().decodeSampleMemos()
        configureTableView()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: Action

    private func memoAddAction(_ action: UIAction) {
        deleteEmptyMemo()
        addMemo()
        showMemo(of: 0)
    }

    // MARK: Method

    func updateMemo(at row: Int, to memo: Memo) {
        let reloadingIndices = (0...row).map { IndexPath(row: $0, section: 0) }

        memos[row] = memo

        if row == 0 {
            tableView.reloadRows(at: reloadingIndices, with: .none)
        } else {
            tableView.reloadRows(at: reloadingIndices, with: .top)
        }
    }

    @discardableResult
    private func deleteEmptyMemo() -> Bool {
        guard memos.first?.title == "" else { return false }

        memos.remove(at: 0)
        tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

        return true
    }

    private func addMemo() {
        memos.append(Memo(title: "", body: "", lastModified: Date().timeIntervalSince1970))
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }

    private func showMemo(of row: Int) {
        let memoViewController = (splitViewController?.viewController(for: .secondary) as? MemoViewController)

        memoViewController?.configure(row: row, memo: memos[row])
        memoViewController?.textViewResignFirstResponder()
        splitViewController?.show(.secondary)
    }

}

// MARK: - UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memoCell = tableView.dequeueReusableCell(withIdentifier: "memoCell",
                                                           for: indexPath) as? MemoCell else { return MemoCell() }
        memoCell.configure(memo: memos[indexPath.row])

        return memoCell
    }

}

// MARK: - UITableViewDelegate

extension MemoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if deleteEmptyMemo() {
            if indexPath.row > 0 {
                showMemo(of: indexPath.row - 1)
            }
        } else {
            showMemo(of: indexPath.row)
        }
    }

}

// MARK: - JSONDecoder

extension JSONDecoder {

    fileprivate func decodeSampleMemos() -> [Memo] {
        guard let data = NSDataAsset(name: "sampleMemos")?.data,
              let memos = try? self.decode([Memo].self, from: data) else { return [] }

        return memos
    }

}
