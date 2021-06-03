//
//  Note.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation

struct Note: Decodable {
    let title: String
    let body: String
    let lastModified: Date
}
