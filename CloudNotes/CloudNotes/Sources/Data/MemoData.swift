//
//  MemoData.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/16.
//

import UIKit

final class MemoData {

    typealias MemoInfo = (id: Int, memo: Memo)

    static let sample = MemoData(name: "sampleMemos")

    private var data: [Int: Memo] = [:]
    private var idCount: Int = 0

    var count: Int {
        return data.count
    }

    var memosByIncreasingID: [MemoInfo] {
        return data.sorted { $0.key < $1.key }.map { ($0.key, $0.value) }
    }

    var memosByRecentModified: [MemoInfo] {
        return memosByIncreasingID.sorted { $0.memo.lastModified > $1.memo.lastModified }.map { ($0.id, $0.memo) }
    }

    init(name: NSDataAssetName) {
        let memos: [Memo] = JSONDecoder().decodeMemos(name: name)
        memos.enumerated().forEach {
            data.updateValue($0.element, forKey: $0.offset)
            idCount += 1
        }
    }

    func createMemo(_ memo: Memo) {
        data.updateValue(memo, forKey: idCount)
        idCount += 1
    }

    func indexByRecentModified(where id: Int) -> Int {
        var row: Int = 0
        for memoInfo in memosByRecentModified {
            if memoInfo.id == id { break }
            row += 1
        }
        return row
    }

    /// Updates the memo stored in the memoData for the given id, or adds a new id-memo pair if the id does not exist.
    func updateMemo(_ memo: Memo, where id: Int) {
        data.updateValue(memo, forKey: id)
    }

    /// Updates the memo stored in the memoData for the given table row.
    func updateMemoByRecentModified(_ memo: Memo, where row: Int) {
        guard 0 <= row && row < count else { return }

        let id: Int = memosByRecentModified[row].id
        data.updateValue(memo, forKey: id)
    }

    /// Removes the given id and its associated memo from the memoData.
    func deleteMemo(where id: Int) {
        data.removeValue(forKey: id)
    }
}

// MARK: - JSONDecoder

extension JSONDecoder {

    fileprivate func decodeMemos(name: NSDataAssetName) -> [Memo] {
        guard let data = NSDataAsset(name: name)?.data,
              let memos = try? self.decode([Memo].self, from: data) else { return [] }

        return memos
    }

}
