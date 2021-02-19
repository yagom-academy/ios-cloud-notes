//
//  MemoModel.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import Foundation

struct MemoModel: Decodable {
    let title: String
    let body: String
    let lastModified: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastModified = "last_modified"
    }
}

extension MemoModel {
    var dateTimeToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.autoupdatingCurrent
        let date = Date(timeIntervalSince1970: lastModified)
        return dateFormatter.string(from: date)
    }
}
