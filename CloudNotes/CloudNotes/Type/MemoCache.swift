//
//  Cache.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/02.
//

import Foundation

struct MemoCache {
    static var shared = MemoCache()
    var updatedFileNameList: [UpdatedFile] = []
    var memoData: [MemoListItem] = []
}
