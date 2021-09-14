//
//  NoteUpdatable.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/08.
//

import Foundation

protocol NoteUpdater: AnyObject {
    func saveContext()
    func createNote()
    func updateNote(at indexPath: IndexPath, with noteData: (title: String, body: String, lastModified: Double))
    func fetchNotes()
    func deleteNote(at indexPath: IndexPath)
}
