//
//  MemoData.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/19.
//

import Foundation

final class MemoData {
    static let shared = MemoData()
    private init() {}
    var list: [Memo] = []
}
