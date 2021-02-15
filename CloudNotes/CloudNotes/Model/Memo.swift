//
//  Memo.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/15.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let body: String
    let modifiedDate: Int

    enum CodingKeys: String, CodingKey {
        case title, body
        case modifiedDate = "last_modified"
    }
}
