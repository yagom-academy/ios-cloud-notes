//
//  Notedata.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/01.
//

import Foundation

struct NoteData: Decodable {
    let title: String?
    let description: String?
    let lastModify: UInt?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "body"
        case lastModify = "last_modified"
    }
}
