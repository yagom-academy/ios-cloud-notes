//
//  NoteListViewControllerDelegate.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/09.
//

import Foundation

protocol NoteListViewControllerDelegate: AnyObject {
    func changeNote(with newText: String)
}
