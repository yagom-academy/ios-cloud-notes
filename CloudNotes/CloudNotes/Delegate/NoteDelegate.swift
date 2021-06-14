//
//  NoteDelegate.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/03.
//

protocol NoteDelegate: AnyObject {
    func showDetailNote(_ listViewController: NoteListViewController, data: NoteViewModel)
}
