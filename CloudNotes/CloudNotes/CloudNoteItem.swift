//
//  CloudNoteItem.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import Foundation

struct CloudNoteItem: Decodable {
    let title: String
    let body: String
    let lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
