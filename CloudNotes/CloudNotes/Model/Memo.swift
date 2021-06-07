//
//  MemoListTableViewCellProperty.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/05/31.
//

import Foundation

struct Memo: Decodable {
    private var title: String
    private var body: String
    private var lastModified: Int
    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
    init(title: String, body: String) {
        self.title = title
        self.body = body
        self.lastModified = Int(Date().timeIntervalSince1970)
    }
    var computedTitle: String {
        get {
            return title
        }
        set {
            title = newValue
        }
    }
    var computedBody: String {
        get {
            return body
        }
        set {
            body = newValue
        }
    }
    var computedlastModifiedDate: Int {
        get {
            return lastModified
        }
        set {
            lastModified = newValue
        }
    }
}



