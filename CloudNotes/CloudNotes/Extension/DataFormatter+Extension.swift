//
//  DataFormatter+Extension.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/09.
//

import Foundation

extension DateFormatter {
    static func convertDoubleTypeToDate(of date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
}
