//
//  NoteUpdatable.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/08.
//

import Foundation

protocol NoteUpdater: class {
    func update(note: Note, at indexPath: IndexPath)
}
