//
//  DateConvertor.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/06.
//

import Foundation

class DateConvertor {
  private let dateFormatter = DateFormatter()
  private var date: String = ""
  
  init(date: Double) {
    let inputDate = Date(timeIntervalSince1970: date)
    self.date = format(date: inputDate)
  }
  
  private func format(date: Date) -> String {
    dateFormatter.locale = Locale(identifier: Locale.current.identifier)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.string(from: date)
  }
  
  func result() -> String {
    return date
  }
}
