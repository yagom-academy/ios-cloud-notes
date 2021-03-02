//
//  Parser.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/03/01.
//

import UIKit

struct Parser {
    static func decodeMemo() -> [TestMemo]? {
        let jsonDecoder = JSONDecoder()
        guard let assetData: NSDataAsset = NSDataAsset(name: "sample") else {
            return nil
        }
        guard let memoList = try? jsonDecoder.decode([TestMemo].self, from: assetData.data) else {
            return nil
        }
        return memoList
    }
}
