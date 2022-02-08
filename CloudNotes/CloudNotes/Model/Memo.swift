//
//  Memo.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import Foundation

struct Memo: Codable {
    let title: String
    let body: String
    let lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
