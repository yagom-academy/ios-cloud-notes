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

    private lazy var memoAddButton = UIBarButtonItem(systemItem: Style.memoAddButtonSystemItem, primaryAction: UIAction(handler: memoAddAction), menu: nil)

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MemoCell.self, forCellReuseIdentifier: MemoCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = Style.navigationItemTitle
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMemoList()
    }

    // MARK: Configure

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
        showMemo(of: Style.updatedMemoRow)
    }

    // MARK: Method

    func updateMemoList() {
        if deleteEmptyMemo() {
            hideMemo()
        }

        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }

    func updateMemo(at row: Int, to memo: Memo) {
        let reloadingIndices: [IndexPath] = (0...row).map { IndexPath(row: $0, section: 0) }
        let indexPathForUpdatedRow = IndexPath(row: Style.updatedMemoRow, section: 0)

        memos[row] = memo

        if row == Style.updatedMemoRow {
            tableView.reloadRows(at: reloadingIndices, with: Style.reloadingRowAnimation)
        } else {
            tableView.reloadRows(at: reloadingIndices, with: Style.reloadingRowsAnimation)
        }

        tableView.selectRow(at: indexPathForUpdatedRow, animated: true, scrollPosition: .none)
    }

    @discardableResult
    private func deleteEmptyMemo() -> Bool {
        guard let firstMemo = memos.first,
              firstMemo.isTitleEmpty else { return false }

        memos.remove(at: Style.updatedMemoRow)
        tableView.deleteRows(at: [IndexPath(row: Style.updatedMemoRow, section: 0)], with: Style.inAndOutRowAnimation)

        return true
    }

    private func addMemo() {
        let indexPathForInsertedRow = IndexPath(row: Style.updatedMemoRow, section: 0)

        memos.append(Memo())
        tableView.insertRows(at: [indexPathForInsertedRow], with: Style.inAndOutRowAnimation)
        tableView.selectRow(at: indexPathForInsertedRow, animated: true, scrollPosition: .none)
    }

    private func showMemo(of row: Int) {
        let memoViewController = (splitViewController?.viewController(for: .secondary) as? MemoViewController)

        memoViewController?.setTextViewHidden(is: false)
        memoViewController?.configure(row: row, memo: memos[row])
        memoViewController?.textViewResignFirstResponder()
        splitViewController?.show(.secondary)
    }

    private func hideMemo() {
        let memoViewController = (splitViewController?.viewController(for: .secondary) as? MemoViewController)

        memoViewController?.setTextViewHidden(is: true)
        memoViewController?.textViewResignFirstResponder()
        splitViewController?.hide(.secondary)
    }

}

// MARK: - UITableViewDataSource

extension MemoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memoCell = tableView.dequeueReusableCell(withIdentifier: MemoCell.reuseIdentifier,
                                                           for: indexPath) as? MemoCell else { return MemoCell() }
        memoCell.configure(memo: memos[indexPath.row])

        return memoCell
    }

}

// MARK: - UITableViewDelegate

extension MemoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if deleteEmptyMemo() {
            indexPath.row > 0 ? showMemo(of: indexPath.row - 1) : hideMemo()
        } else {
            showMemo(of: indexPath.row)
        }
    }

}

// MARK: - Style

extension MemoListViewController {

    enum Style {
        static let memoAddButtonSystemItem: UIBarButtonItem.SystemItem = .add

        static let navigationItemTitle: String = "메모"

        static let updatedMemoRow: Int = 0

        static let reloadingRowAnimation: UITableView.RowAnimation = .none
        static let reloadingRowsAnimation: UITableView.RowAnimation = .top
        static let inAndOutRowAnimation: UITableView.RowAnimation = .automatic
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
