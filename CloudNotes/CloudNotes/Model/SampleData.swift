//
//  SampleData.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/16.
//

import Foundation

struct SampleData: Decodable {
    let title: String
    let body: String
    let timeStamp: Double
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case timeStamp = "last_modified"
    }
    
    func convertFormatToString() -> String {
        let lastModifiedDate = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: lastModifiedDate)
    }
}
