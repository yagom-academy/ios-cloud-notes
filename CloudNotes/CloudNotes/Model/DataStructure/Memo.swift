//
//  Memo.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/03.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let body: String
    let lastModified: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
