//
//  Memo.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import Foundation

struct Memo: Decodable {
    var title: String
    var body: String
    var lastDate: Double

    enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastDate = "last_modified"
    }
}

extension Memo {
    mutating func update(with memo: Memo) {
        self.title = memo.title
        self.body = memo.body
        self.lastDate = memo.lastDate
    }
}
