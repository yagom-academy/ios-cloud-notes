//
//  DateManager.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/04.
//

import Foundation

class DateManager {
    private static let formatter: DateFormatter = {
       let dateFommatter = DateFormatter()
        dateFommatter.locale = Locale(identifier: "ko_KR")
        dateFommatter.dateStyle = .medium
        return dateFommatter
    }()

    static func transfromFormatedDate(from timeInterval: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeInterval)
        return formatter.string(for: date)
    }
}
