//
//  Note.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/18.
//

import Foundation

struct Note {
    let title: String
    let body: String
    let lastModifiedDate: String
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
}

extension Note {
    init(title: String, body: String) {
        self.title = title
        self.body = body
        self.lastModifiedDate = dateFormatter.string(from: Date())
    }
}
