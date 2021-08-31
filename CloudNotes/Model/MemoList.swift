//
//  MemoList.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import Foundation

struct MemoList {
    let memo: [Memo]
    
    subscript(index: Int) -> Memo {
        return memo[index]
    }
}
