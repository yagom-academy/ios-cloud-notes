//
//  Memo.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/06.
//

import Foundation

struct Memo: Decodable {

    var title: String?
    var body: String?
    var lastModified: Int?

    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
