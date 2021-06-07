//
//  MemoInfo.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import Foundation

struct MemoInfo: Decodable {
  let title: String
  let lastModified: Double
  let body: String
  
  private enum CodingKeys: String, CodingKey {
    case title, body
    case lastModified = "last_modified"
  }
}
