//
//  CloudString.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/03/04.
//

import Foundation

enum CloudString {
    static let requiredScope = ["files.content.read", "files.content.write"]
    static let fileNames = ["/CloudNotes.sqlite", "/CloudNotes.sqlite-wal", "/CloudNotes.sqlite-shm"]
}
