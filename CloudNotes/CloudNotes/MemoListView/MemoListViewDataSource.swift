//
//  MemoListViewDataSource.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class MemoListViewDataSource: NSObject, UITableViewDataSource {
    private var memoList = [Memo]()

    subscript(indexPath: IndexPath) -> Memo {
        return memoList[indexPath.row]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memoListViewCell = tableView.dequeueReusableCell(
                withIdentifier: MemoListViewCell.identifier
        ) as? MemoListViewCell else {
            return UITableViewCell()
        }

        memoListViewCell.configure(with: memoList[indexPath.row])

        return memoListViewCell
    }

    func tableView(_ tableView: UITableView, initializeMemoListWith memoList: [Memo]) {
        self.memoList = memoList
        tableView.reloadData()
    }

    func tableView(
        _ tableView: UITableView,
        updateRowAt indexPath: IndexPath,
        with memo: Memo?
    ) {
        guard let memo = memo else {
            return
        }

        memoList[indexPath.row] = memo
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
