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
    private var uuid = UUID()
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
    
    init(title: String, body: String, lastModified: Date) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }

    init(with existingNote: Note, title: String, body: String, lastModified: Date) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
        self.uuid = existingNote.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
