//
//  MemoItemProvider.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit

final class MemoProvider {
  private var memo: [Memo]?
  
  func getMockData() throws -> [Memo]? {
    guard let dataAsset = NSDataAsset(name: "sample") else { return nil }
    let data = try JSONDecoder().decode([Memo].self, from: dataAsset.data)
    self.memo = data
    return memo
  }
}
