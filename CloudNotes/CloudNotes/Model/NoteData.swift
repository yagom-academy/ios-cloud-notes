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
    
    func title(index: Int) -> String? {
        if noteLists.count > index {
            return noteLists[index].title
        } else {
            return nil
        }
    }
    
    func body(index: Int) -> String? {
        if noteLists.count > index {
            return noteLists[index].body
        } else {
            return nil
        }
    }
    
    func lastModifiedDate(index: Int) -> String? {
        if noteLists.count > index {
            return noteLists[index].lastModifiedDate
        } else {
            return nil
        }
    }
}
