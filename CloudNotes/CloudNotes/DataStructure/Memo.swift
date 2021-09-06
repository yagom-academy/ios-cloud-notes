//
//  MemoSample.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/06.
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
