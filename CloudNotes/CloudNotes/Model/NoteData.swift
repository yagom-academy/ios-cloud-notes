//
//  NotesData.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/17.
//

import Foundation

class NoteData {
    static let shared = NoteData()
    var noteLists: [Note] = []
    
    private init() {}
}
