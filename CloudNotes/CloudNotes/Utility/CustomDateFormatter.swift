//
//  CustomDateFormatter.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/19.
//

import Foundation

struct CustomDateFormatter {
    static let utcFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter
    }()
}
