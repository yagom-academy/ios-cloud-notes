//
//  NoteUpdater.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/17.
//

import Foundation

protocol NoteUpdater: NSObject {
    func createNote()
    func updateNote(at indexPath: IndexPath,
                    with noteData: (title: String, body: String, lastModified: Double))
    func deleteNote(at indexPath: IndexPath)
}
