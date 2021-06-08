//
//  Memo.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/05/31.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let body: String
    let lastModified: Double
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
    
}
