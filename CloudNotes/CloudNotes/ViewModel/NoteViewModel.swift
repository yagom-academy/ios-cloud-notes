//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/06.
//

import Foundation

struct NoteViewModel {
    let note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    var title: String {
        return note.title
    }

    var formattedLastModified: String {
        return note.formattedLastModified
    }

    var body: String {
        return note.body
    }
}
