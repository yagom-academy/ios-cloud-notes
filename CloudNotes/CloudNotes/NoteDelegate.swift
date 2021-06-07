//
//  NoteDelegate.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/03.
//

import Foundation

protocol NoteDelegate: AnyObject {
    func showDetailNote(data: NoteViewModel)
}
