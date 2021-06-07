//
//  MemoDetailViewModel.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation

final class MemoDetailViewModel {
  private let whiteSpace = ""
  private let emptyParagraph = "\n\n"
  var delegate: MemoDetailViewModelDelegate?
  
  private var memo: Memo = Memo(title: "", body: "", lastModified: 0) {
    willSet {
      self.date = newValue.lastModified
      self.content = newValue.title + emptyParagraph + newValue.body
      delegate?.changeMemo(content: content)
    }
  }
  
  lazy var date: Int = { return memo.lastModified }()
  lazy var content: String = {
    return memo.title + emptyParagraph + memo.body
  }()
  
  func configure(with memo: Memo) {
    self.memo = memo
  }
}

protocol MemoDetailViewModelDelegate: NSObject {
  func changeMemo(content: String)
}
