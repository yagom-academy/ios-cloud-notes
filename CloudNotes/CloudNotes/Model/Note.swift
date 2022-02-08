//
//  Note.swift
//  CloudNotes
//
//  Created by JeongTaek Han on 2022/02/08.
//

import Foundation

struct Note: Codable {
    
    let title: String
    let body: String
    let lastModified: Date
    
}
