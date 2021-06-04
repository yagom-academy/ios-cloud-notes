//
//  Note.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation

struct Note: Decodable, Hashable {
    let title: String
    let body: String
    let lastModified: Date
    private let uuid = UUID()
    
    init(title: String, body: String, lastModified: Date) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }

    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
