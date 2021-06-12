//
//  DateConvertor.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/06.
//

import Foundation

class DateConvertor {
  func numberToString(number: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: number)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: Locale.current.identifier)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
  }
  
  func dateToNumber(date: Date) -> TimeInterval {
    return date.timeIntervalSince1970
  }
}
