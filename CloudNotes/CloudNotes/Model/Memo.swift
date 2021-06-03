//
//  Sample.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation

struct Memo: Decodable {
  let title: String
  let body: String
  private let lastModified: Int
  var lastModifiedDate: String {
    let date = Date(timeIntervalSince1970: TimeInterval(lastModified))
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: Locale.current.identifier)
    dateFormatter.dateFormat = "yyyy. MM. dd"
    return dateFormatter.string(from: date)
  }
}

extension Memo {
  enum CodingKeys: String, CodingKey {
    case title, body
    case lastModified = "last_modified"
  }
}
