//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/06.
//

import Foundation

struct NoteViewModel {
    var note: NoteData
    
    var title: String {
        return note.title
    }
    
    var formattedLastModified: String {
        let date = Date(timeIntervalSince1970: TimeInterval(note.lastModified))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    var body: String {
        return note.body
    }
}
