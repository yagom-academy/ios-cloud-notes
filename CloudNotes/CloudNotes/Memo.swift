//
//  Memo.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let body: String
    let lastModified: Double
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
