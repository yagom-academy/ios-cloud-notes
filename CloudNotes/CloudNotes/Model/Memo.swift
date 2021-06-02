//
//  MemoListTableViewCellProperty.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/05/31.
//

import Foundation

struct Memo: Decodable {
    var title: String
    var body: String
    var lastModified: Int
    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
