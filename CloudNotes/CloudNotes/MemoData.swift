//
//  MemoData.swift
//  CloudNotes
//
//  Created by sookim on 2021/05/31.
//

import Foundation

struct MemoData: Decodable {
    
    let title: String
    let body: String
    let lastModified: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
    
}
