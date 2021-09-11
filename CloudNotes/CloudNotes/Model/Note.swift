//
//  Note.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/07.
//

import Foundation

struct Note: Decodable {
    var title: String
    var body: String
    var lastModified: Double
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
