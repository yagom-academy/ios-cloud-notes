//
//  MemoInfo.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import Foundation

struct MemoInfo {
  let title: String
  let date: String
  let memo: String
  let summary: String
  
  init(title: String, date: String, memo: String) {
    self.title = title
    self.date = date
    self.memo = memo
    self.summary = memo
  }
}
