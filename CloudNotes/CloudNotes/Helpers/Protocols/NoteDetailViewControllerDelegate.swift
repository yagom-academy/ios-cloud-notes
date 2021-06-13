//
//  NoteDetailViewControllerDelegate.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/04.
//

import UIKit

protocol NoteDetailViewControllerDelegate: AnyObject {
    func showNote(with note: Note)
    func setIndexPathForSelectedNote(_ indexPath: IndexPath)
}
