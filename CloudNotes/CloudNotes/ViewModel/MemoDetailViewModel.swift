//
//  MemoDetailViewModel.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation

final class MemoDetailViewModel {
  private var memo: Memo?
  private var title: String { return memo?.title ?? "" }
  private var body: String { return memo?.body ?? "" }
  
  var date: String { return memo?.lastModifiedDate ?? "?" }
  lazy var content: String = {
    return title + "\n\n" + body
  }()
  
  func configure(with memo: Memo) {
    self.memo = memo
  }
}
