//
//  MemoListVCModel.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import UIKit

class MemoListViewControllerModel {
    var memo: [Memo] = []
    
    func loadSampleData() {
        guard let assetData: NSDataAsset = NSDataAsset(name: "sample") else { return }
        guard let memoData = try? JSONDecoder().decode([Memo].self, from: assetData.data) else { return }
        
        self.memo = memoData
    }
    
    func readMemo(index: Int) -> Memo {
        return self.memo[index]
    }
    
    func countMemo() -> Int {
        return self.memo.count
    }
    
}
