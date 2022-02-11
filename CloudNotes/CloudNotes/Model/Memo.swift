//
//  Memo.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import Foundation

struct Memo {
    let id: UUID
    let title: String
    let body: String
    let lastModified: TimeInterval
}
