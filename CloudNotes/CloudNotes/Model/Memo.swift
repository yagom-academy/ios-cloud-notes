//
//  Memo.swift
//  CloudNotes
//
//  Created by sole on 2021/02/16.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let contents: String
    private let lastModified: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case contents = "body"
        case lastModified = "last_modified"
    }
}

extension Memo {
    var lastModifiedDateToString: String {
        let date = Date(timeIntervalSince1970: lastModified)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy. MM. dd."
        return dateFormatter.string(from: date)
    }
}
