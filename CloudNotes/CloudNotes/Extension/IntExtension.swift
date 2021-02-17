//
//  IntExtension.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import Foundation

extension Int {
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.locale = Locale.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy.MM.dd"
            
            return dateFormatter
        }()
    }
    
    var stringFromUTC: String? {
        return Formatter.utcFormatter.string(from: Date(timeIntervalSince1970: Double(self)))
    }
}
