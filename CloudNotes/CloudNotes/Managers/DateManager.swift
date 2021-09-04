//
//  DateManager.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/04.
//

import Foundation

class DateManager {
    private static let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateFormat = "yyyy. MM. dd"
        return f
    }()

    static func transfromFormatedDate(from timeInterval: Double) -> String? {
        let date = Date(timeIntervalSince1970: timeInterval)
        return formatter.string(for: date)
    }
}
