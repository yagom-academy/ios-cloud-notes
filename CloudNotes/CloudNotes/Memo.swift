//
//  Memo.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/03.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let description: String
    let lastModifiedDate: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "body"
        case lastModifiedDate = "last_modified"
    }
}
