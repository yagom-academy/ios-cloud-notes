//
//  Note.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

struct Note: Decodable {
    let title: String
    let body: String
    let lastModified: UInt

    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
