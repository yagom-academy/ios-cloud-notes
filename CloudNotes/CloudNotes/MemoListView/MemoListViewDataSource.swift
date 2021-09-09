//
//  MemoListViewDataSource.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class MemoListViewDataSource: NSObject, UITableViewDataSource {
    private lazy var memoList: [Memo] = loadMemoListForTest() ?? []

    var lastIndexPath: IndexPath {
        return IndexPath(row: memoList.count, section: .zero)
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

    private func loadMemoListForTest() -> [Memo]? {
        let assetName = "sampleData"

        guard let asset = NSDataAsset(name: assetName),
              let parsedAsset = try? JSONSerialization.jsonObject(
                with: asset.data,
                options: JSONSerialization.ReadingOptions()
              ) as? [[String: Any]] else {
            return nil
        }

        let memoList: [Memo] = parsedAsset.map { dictionary in
            let decodedDictionary = Parser.decode(from: dictionary, to: Memo.self)

            guard let memo = try? decodedDictionary.get() else {
                let corrupted = "Corrupted"

                return Memo(
                    title: corrupted,
                    description: corrupted,
                    lastUpdatedTime: .zero
                )
            }

            return memo
        }

        return memoList
    }
}
