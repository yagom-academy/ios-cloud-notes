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
    var lastModifiedDate: String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(lastModified))
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter.string(from: date)
    }
}
