//
//  MemoData.swift
//  CloudNotes
//
//  Created by TORI on 2021/06/04.
//

import Foundation

struct MemoData: Decodable {
    let title: String
    let body: String
    let lastModified: Double
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
