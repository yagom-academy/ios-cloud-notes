//
//  MemoListViewModel.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import UIKit
import CoreData

final class MemoListViewModel {
    private var memo: [MemoData] = []
    let coreDataStack: CoreDataStack = CoreDataStack.shared
    var editingMemo: MemoData?
    
    init() {
        self.getAllMemoData()
    }
    
    func getAllMemoData() {
        self.memo = coreDataStack.fetch()
    }
    
    func readMemo(index: Int) -> MemoData {
        return self.memo[index]
    }
    
    func countMemo() -> Int {
        return self.memo.count
    }
    
    func setupEditingMemo(index: Int) {
        self.editingMemo = self.memo[index]
    }
    
    func memoDataText(data: MemoData) -> String {
        guard let title = data.title,
              let body = data.body else {
            return "non data"
        }
        
        return "\(title)\(body)"
    }
    
}
