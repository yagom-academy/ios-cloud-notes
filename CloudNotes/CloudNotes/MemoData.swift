//
//  MemoData.swift
//  CloudNotes
//
//  Created by TORI on 2021/06/04.
//

import Foundation

struct MemoData {
    let title: String
    let body: String
    let lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case last_modified = "lastModified"
    }
}
