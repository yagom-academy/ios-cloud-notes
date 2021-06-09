//
//  NoteListViewControllerDelegate.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/09.
//

import Foundation

protocol NoteListViewControllerDelegate: AnyObject {
    var editingNote: Note? { get }
    func changeNote(with newNote: Note)
}
