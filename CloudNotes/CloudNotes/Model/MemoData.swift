//
//  MemoData.swift
//  CloudNotes
//
//  Created by sookim on 2021/05/31.
//

import Foundation

struct MemoData: Decodable {
    
    let title: String
    let body: String
    private let lastModified: TimeInterval
    var lastModifiedDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = Date(timeIntervalSince1970: lastModified)

            return dateFormatter.string(from: date)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
    
}
