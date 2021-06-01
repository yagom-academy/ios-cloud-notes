//
//  Memo.swift
//  CloudNotes
//
//  Created by steven on 2021/06/01.
//

import Foundation

struct Memo: Codable {
    let title: String
    let body: String
    let lastModified: Int
}
