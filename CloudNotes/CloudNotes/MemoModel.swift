//
//  MemoModel.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/15.
//

import UIKit

struct MemoModel {
    static func getData() -> [Memo]? {
        let fileName = "sample"
        let file = NSDataAsset(name: fileName)
        let Memos = try? JSONDecoder().decode([Memo].self, from: file!.data)
        dump(Memos)
        return Memos
    }
}
