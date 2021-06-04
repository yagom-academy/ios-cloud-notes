//
//  MemoViewModel.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import Foundation

class MemoViewModel {
  var memoInfo: MemoInfo?
  
  func update(model: MemoInfo?) {
    memoInfo = model
  }
}
