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
    func update(with NoteData: Note, at indexPath: IndexPath)
    func fetchNotes()
    func deleteNote(at indexPath: IndexPath)
}
