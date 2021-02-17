//
//  Memo.swift
//  CloudNotes
//
//  Created by sole on 2021/02/16.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let contents: String
    let lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case contents = "body"
        case lastModified = "last_modified"
    }
}
