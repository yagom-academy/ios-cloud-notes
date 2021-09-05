//
//  Memo.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/03.
//

struct Memo: Decodable {
    var title: String
    var body: String
    var lastModified: Double
    
    mutating func updateMemo(_ title: String, _ body: String, _ lastModified: Double) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }
}
