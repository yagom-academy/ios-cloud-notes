//
//  MemoDetailViewModel.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation
import CoreData

final class MemoDetailViewModel {
  private enum ContentConstant {
    static let emptyString = ""
    static let doubleNewLine = "\n\n"
  }
  
  var delegate: MemoDetailViewModelDelegate?
  
  private var memo: Memo?
  var date: Date { return (memo!.lastModified)! }
  var content: String { return memo!.title! + ContentConstant.doubleNewLine + memo!.body! }
  
  func configure(with memo: Memo) {
    self.memo = memo
    delegate?.changeMemo(content: content)
  }
}

protocol MemoDetailViewModelDelegate: NSObject {
  func changeMemo(content: String)
}
