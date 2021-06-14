//
//  NoteDelegate.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

protocol NoteDelegate: AnyObject {
    func deliverToDetail(_ data: Note?, first: Bool, index: IndexPath)
    func deliverToPrimary(_ text: UITextView, first: Bool, index: IndexPath?)
}
