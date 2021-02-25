//
//  Note.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/18.
//

import Foundation

class Note {
    var title: String
    var body: String
    var lastModifiedDate: Date
    
    init(title: String, body: String, lastModifiedDate: Date) {
        self.title = title
        self.body = body
        self.lastModifiedDate = lastModifiedDate
    }
    
    convenience init(title: String, body: String) {
        self.init(title: title, body: body, lastModifiedDate: Date())
    }
}
