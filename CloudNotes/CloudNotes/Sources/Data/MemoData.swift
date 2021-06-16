//
//  MemoData.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/16.
//

import UIKit

final class MemoData {

    static let sample = MemoData(name: "sampleMemos")

    private var data: [Int: Memo] = [:]

    var count: Int { return data.count }

    init(name: NSDataAssetName) {
        let memos: [Memo] = JSONDecoder().decodeMemos(name: name)
        memos.enumerated().forEach({ data.updateValue($0.element, forKey: $0.offset) })
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
