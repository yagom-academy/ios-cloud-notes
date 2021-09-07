//
//  Formatter.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/06.
//

import Foundation

class CustomDateFormatter {
    private let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
    
        return formatter
    }
    
    let dateString: String
    
    init(lastModifiedDateInt: Int?) {
        let date = Date(timeIntervalSince1970: Double(lastModifiedDateInt ?? .zero))
        let dateString = self.dateFormatter().string(from: date)
        self.dateString = dateString
    }
}
