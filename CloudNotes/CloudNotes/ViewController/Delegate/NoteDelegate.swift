//
//  NoteDelegate.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/03.
//
import UIKit

protocol NoteDelegate: AnyObject {
    func showDetailNote(_ listViewController: NoteListViewController, indexPath: IndexPath)
}
