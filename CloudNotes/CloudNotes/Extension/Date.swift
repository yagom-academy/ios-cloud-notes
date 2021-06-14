//
//  Date.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/13.
//

import Foundation

extension Date {
   func currentDateToString() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: today)
    }
}
