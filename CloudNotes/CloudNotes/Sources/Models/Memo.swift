//
//  Memo.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/02.
//

import Foundation

struct Memo: Decodable {

    let title: String
    let body: String
    let lastModified: TimeInterval

    var isTitleEmpty: Bool { title == "" }
    var isBodyEmpty: Bool { body == "" }

    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }

}
