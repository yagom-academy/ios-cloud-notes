//
//  MemoListVCModel.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import Foundation
import UIKit

class MemoListVCModel {
    var memo: [Memo] = []
    
    func loadSampleData() {
        guard let assetData: NSDataAsset = NSDataAsset(name: "sample") else {
            print("에셋에서 데이터 읽기 실패")
            return
        }
        
        guard let memoData = try? JSONDecoder().decode([Memo].self, from: assetData.data) else {
            print("JSONdecode 실패")
            return
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
