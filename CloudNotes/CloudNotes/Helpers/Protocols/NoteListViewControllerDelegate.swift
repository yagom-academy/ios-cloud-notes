//
//  NoteListViewControllerDelegate.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/11.
//

import UIKit

protocol NoteListViewControllerDelegate: AnyObject {
    var currentIndexPathOfEditingNote: IndexPath { get }
    func applyTextUpdate(with newText: String)
    func deleteTapped(at indexPath: IndexPath)
    func activityViewTapped(at indexPath: IndexPath)
}
