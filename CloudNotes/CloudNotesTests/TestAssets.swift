//
//  TestAssets.swift
//  CloudNotesTests
//
//  Created by Ryan-Son on 2021/06/14.
//

import Foundation

enum TestAssets {
    static let (title, body, date) = ("abc", "123", Date(timeIntervalSince1970: 0))
    static let (updatedTitle, updatedBody, updatedDate) = ("Updated Title", "Updated Body", Date())
    static let titleBodySeparator = "\n"
    static let indexPathOfFirstNote = IndexPath(item: 0, section: 0)
}
