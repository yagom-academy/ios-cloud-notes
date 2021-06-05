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
  let lastModified: Int
}

extension Memo {
  enum CodingKeys: String, CodingKey {
    case title, body
    case lastModified = "last_modified"
  }
}
