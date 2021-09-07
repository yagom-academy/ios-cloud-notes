//
//  Note.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/07.
//

import Foundation

struct Note: Decodable {
    let title: String
    let body: String
    let lastModified: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
