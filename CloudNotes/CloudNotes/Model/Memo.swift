//
//  Memo.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/08/31.
//

import Foundation

struct Memo: Codable {
    var title: String
    var body: String
    var date: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "last_modified"
    }
}
