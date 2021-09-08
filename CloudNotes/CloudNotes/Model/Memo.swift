//
//  Memo.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import Foundation

class Memo: Decodable {
    var title: String
    var body: String
    var lastDate: Double

    enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastDate = "last_modified"
    }

    init(title: String, body: String, lastDate: Double) {
        self.title = title
        self.body = body
        self.lastDate = lastDate
    }
}

extension Memo {
    func update(with memo: Memo) {
        self.title = memo.title
        self.body = memo.body
        self.lastDate = memo.lastDate
    }
}
