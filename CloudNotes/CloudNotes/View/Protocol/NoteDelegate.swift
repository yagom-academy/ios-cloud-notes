//
//  NoteDelegate.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import Foundation

protocol NoteDelegate {
    func deliverToDetail(_ data: NoteData)
}
