//
//  MemoListVCModel.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import UIKit

enum MemoListViewControllerModelError: Error {
    case failLoadAssetData
    case failDecodeData
}

class MemoListViewControllerModel {
    var memo: [Memo] = []
    
    func loadSampleData() throws {
        guard let assetData: NSDataAsset = NSDataAsset(name: "sample") else {
            throw MemoListViewControllerModelError.failLoadAssetData
        }
        
        guard let memoData = try? JSONDecoder().decode([Memo].self, from: assetData.data) else {
            throw MemoListViewControllerModelError.failDecodeData
        }
        
        self.memo = memoData
    }
    
    func readMemo(index: Int) -> Memo {
        return self.memo[index]
    }
    
    func countMemo() -> Int {
        return self.memo.count
    }
    
}
