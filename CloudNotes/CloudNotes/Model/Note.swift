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
    let lastModifiedDate: Date
    
    func convertFormatToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: lastModifiedDate)
    }
}
