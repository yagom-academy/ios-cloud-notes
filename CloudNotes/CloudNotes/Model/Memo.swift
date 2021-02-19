//
//  Memo.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import UIKit

class Memo {
    static let shared = Memo()
    private init() {}
    var list: [MemoModel] = []
    
    // MARK: - Decode
    // TODO: 현재는 data 변경이 없지만 이후, data 변경 및 메모 추가시에는 마지막 index로 trimming한 후 append하도록 변경하기
    func decodeMemoData() throws {
        let jsonDecoder = JSONDecoder()
        guard let memoJsonData: NSDataAsset = NSDataAsset(name: "sample") else {
            throw MemoError.decodeData
        }
        self.list = try jsonDecoder.decode([MemoModel].self, from: memoJsonData.data)
    }
}
