//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoListViewController: RootViewController {
    var memoList: [Memo] = []
    private let memoView = MemoListView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMemo()
    }

    override func setup() {
        self.view = memoView
        memoView.memoTableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.reuseIdentifier)
        memoView.memoTableView.delegate = self
        memoView.memoTableView.dataSource = self

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.title = "메모"
    }

    private func prepareMemo() {
        let jsonHandler = JSONHandler()
        guard let jsonData = JsonUtil.loadJsonData("sample") else { return }
        guard let memo = jsonHandler.decode(with: jsonData, to: [Memo].self) else { return }
        memoList.append(contentsOf: memo)
    }

    @objc func addTapped() {
        memoList.append(Memo(title: "", body: "", lastDate: Date().timeIntervalSince1970))
        memoView.memoTableView.reloadData()
        memoList.last.flatMap {
            let detailViewController = MemoDetailViewController()
            detailViewController.configure(with: $0, index: memoList.index(before: memoList.endIndex))
            let nextViewController = UINavigationController()
            nextViewController.viewControllers = [detailViewController]
            self.showDetailViewController(nextViewController, sender: self)
        }
        scrollToBottom()
    }

    private func scrollToBottom() {
        let indexPath = IndexPath(row: memoList.endIndex - 1, section: 0)
        memoView.memoTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.reuseIdentifier) as? MemoListCell else { fatalError() }
        cell.configure(with: prepareForPresent(from: memoList[indexPath.row]))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = MemoDetailViewController()
        detailViewController.configure(with: memoList[indexPath.row], index: indexPath.row)
        let nextViewController = UINavigationController()
        nextViewController.viewControllers = [detailViewController]
        detailViewController.delegate = self
        self.showDetailViewController(nextViewController, sender: self)
    }
}

extension MemoListViewController {
    private func prepareForPresent(from memo: Memo) -> MemoPresentModel {
        return .init(title: memo.title,
                     body: memo.body,
                     date: DateFormatter.localizedString(from: Date(timeIntervalSince1970: memo.lastDate), dateStyle: .long, timeStyle: .none))
    }
}

extension MemoListViewController: Memorizable {
    func saveMemo(with newMemo: Memo, index: Int) {
        memoList[index].title = newMemo.title
        memoList[index].body = newMemo.body
        memoList[index].lastDate = newMemo.lastDate
        memoView.memoTableView.reloadData()
    }
}
