//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MemoViewController: UIViewController {
    private var memoList: [Memo] = []
    private let memoTableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMemo()
        self.navigationItem.title = "메모"
        view.addSubview(memoTableView)
        configureTableView()
    }

    func prepareMemo() {
        let jsonHandler = JSONHandler()
        guard let jsonData = JsonUtil.loadJsonData("sample") else { return }
        guard let memo = jsonHandler.decode(with: jsonData, to: [Memo].self) else { return }
        memoList.append(contentsOf: memo)
    }
}

private extension MemoViewController {
    func configureTableView() {
        memoTableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.reuseIdentifier)
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    memoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    memoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    memoTableView.topAnchor.constraint(equalTo: view.topAnchor),
                    memoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}

extension MemoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.reuseIdentifier) as? MemoListCell else { fatalError() }
        cell.configure(with: prepareForPresent(from: memoList[indexPath.row]))
        return cell
    }
}

extension MemoViewController {
    fileprivate func prepareForPresent(from memo: Memo) -> MemoPresentModel {
        return .init(title: memo.title,
                     body: memo.body,
                     date: DateFormatter.localizedString(from: Date(timeIntervalSince1970: memo.lastModified), dateStyle: .long, timeStyle: .none))
    }
}
