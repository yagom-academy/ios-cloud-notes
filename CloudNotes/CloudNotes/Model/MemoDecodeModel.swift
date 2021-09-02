//
//  JSONDecodeModel.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/01.
//

import Foundation

// MARK: - Model when used decoding sample JSON file
struct MemoDecodeModel: Decodable {
    let item: [Item]
    
    struct Item: Decodable {
        let title: String
        let body: String
        let lastModified: Int
        
        enum CodingKeys: String, CodingKey {
            case title, body
            case lastModified = "last_modified"
        }
    }
}
