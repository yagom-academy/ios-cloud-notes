//
//  CloudNoteItem.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import Foundation

struct CloudNoteItem: Decodable {
    var title: String
    var body: String
    var lastModified: Date
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
