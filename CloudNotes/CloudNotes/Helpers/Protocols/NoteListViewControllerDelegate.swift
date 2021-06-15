//
//  NoteManagerDelegate.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/09.
//

import UIKit

protocol NoteListViewControllerDelegate: AnyObject {
    func applyTextUpdate(with newText: String)
}
