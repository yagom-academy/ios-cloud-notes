//
//  MemoListViewDataSource.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class MemoListViewDataSource: NSObject, UITableViewDataSource {
    private var memoList = [Memo]()

    var lastIndexPath: IndexPath {
        return IndexPath(row: memoList.count - 1, section: .zero)
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
}
