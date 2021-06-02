//
//  MemoListTableViewCellProperty.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/05/31.
//

import Foundation

struct Memo: Decodable {
    var title: String
    var body: String
    var lastModified: Int
    private enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
    
    func getLastModified() -> String {
        let currentLocale = Locale.current.collatorIdentifier ?? "ko_KR"
        let dateFormatter = DateFormatter()
                
        dateFormatter.locale = Locale(identifier: currentLocale)
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy. MM. dd.")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(lastModified)))
    }
}
