//
//  NoteDelegate.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import Foundation

protocol NoteDelegate: AnyObject {
    func deliverToDetail(_ data: Note)
}
