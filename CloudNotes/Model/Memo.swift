//
//  Memo.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import Foundation

class Memo: Decodable {
    let title: String
    let description: String
    let lastUpdatedTime: TimeInterval

    init(title: String, description: String, lastUpdatedTime: TimeInterval) {
        self.title = title
        self.description = description
        self.lastUpdatedTime = lastUpdatedTime
    }

    enum CodingKeys: String, CodingKey {
        case title
        case description = "body"
        case lastUpdatedTime = "last_modified"
    }
}
