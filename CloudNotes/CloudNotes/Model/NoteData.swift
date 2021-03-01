//
//  NotesData.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/17.
//

import Foundation

//class NoteData {
//    static let shared = NoteData()
//    private var noteLists: [Note] = []
//    var count: Int {
//        return noteLists.count
//    }
//    
//    private init() {}
//    
//    func note(index: Int) -> Note? {
//        guard noteLists.count > index, index >= 0 else {
//            return nil
//        }
//        
//        return noteLists[index]
//    }
//    
//    func add(note: Note) {
//        noteLists.append(note)
//    }
//    
//    func title(index: Int) -> String? {
//        if noteLists.count > index {
//            return noteLists[index].title
//        } else {
//            return nil
//        }
//    }
//    
//    func body(index: Int) -> String? {
//        if noteLists.count > index {
//            return noteLists[index].body
//        } else {
//            return nil
//        }
//    }
//    
//    func lastModifiedDate(index: Int) -> Date? {
//        if noteLists.count > index {
//            return noteLists[index].lastModifiedDate
//        } else {
//            return nil
//        }
//    }
//}
