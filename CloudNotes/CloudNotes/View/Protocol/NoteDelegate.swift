//
//  NoteDelegate.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

protocol NoteDelegate: AnyObject {
    func deliverToDetail(_ data: Note?, index: IndexPath)
    func deliverToPrimary(_ data: UITextView, index: IndexPath?)
    func clearNote()
    func backToPrimary()
}
