//
//  DateConvertor.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/06.
//

import Foundation

class DateConvertor {
  private let dateFormatter = DateFormatter()

  func numberToString(number: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: number)
    dateFormatter.locale = Locale(identifier: Locale.current.identifier)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
  }
  
  func dateToNumber(date: Date) -> TimeInterval {
    return date.timeIntervalSince1970
  }
}
