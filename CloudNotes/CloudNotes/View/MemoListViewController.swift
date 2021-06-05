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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewMemo))
    }

    private func fetchData() {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        do {
            let request = Memo.fetchRequest() as NSFetchRequest<Memo>
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            memos = try context?.fetch(request)
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

    @objc private func createNewMemo() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }

        let newMemo = Memo(context: context)
        newMemo.title = "\(Date())"
        newMemo.date = Date()

        try? context.save()
        fetchData()

        let newIndexPath = IndexPath(row: 0, section: 0)
        memoListTableView.insertRows(at: [newIndexPath], with: .automatic)

        let memoDetailViewController = MemoDetailViewController(memoListViewDelegate: self)
        memoDetailViewController.fetchData(memo: newMemo, indexPath: newIndexPath)
        memoListTableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .top)
        splitViewDelegate?.didSelectRow(memo: newMemo, indexPath: newIndexPath, memoListViewDelegate: self)
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

    func deleteCell(indexPath: IndexPath) {
        fetchData() // to refresh memos (delete deleted memo from local variable 'memos')
        memoListTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
