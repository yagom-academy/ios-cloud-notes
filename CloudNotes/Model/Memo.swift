//
//  Memo.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let description: String
    let lastUpdatedTime: Date

    enum CodingKeys: String, CodingKey {
        case title
        case description = "body"
        case lastUpdatedTime = "last_modified"
    }
}
