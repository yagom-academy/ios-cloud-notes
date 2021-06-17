//
//  CoreDataDelegate.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/15.
//

import Foundation

protocol CoreDataDelegate {
    func insert(current: IndexPath?, new: IndexPath?)
    func delete(current: IndexPath?, new: IndexPath?)
    func move(current: IndexPath?, new: IndexPath?)
    func update(current: IndexPath?, new: IndexPath?)
}
