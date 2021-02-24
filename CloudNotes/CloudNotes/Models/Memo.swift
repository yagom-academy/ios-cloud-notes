//
//  Memo.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/15.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let body: String
    let lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
