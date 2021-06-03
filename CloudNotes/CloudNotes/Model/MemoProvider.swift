//
//  MemoItemProvider.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

final class MemoProvider {
  private var memo: [Memo]?
  
  func setMockData() throws {
    guard let dataAsset = NSDataAsset(name: "sample") else { return }
    let data = try JSONDecoder().decode([Memo].self, from: dataAsset.data)
    self.memo = data
  }
  
  func getMemo() -> [Memo]? {
    return memo
  }
}
