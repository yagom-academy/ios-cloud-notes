//
//  Memo.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let body: String
    let lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastModified = "last_modified"
    }
}
