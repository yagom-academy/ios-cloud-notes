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

  private var memo: Memo?
  private var title: String { return memo?.title ?? whiteSpace }
  private var body: String { return memo?.body ?? whiteSpace }
  
  var date: Int { return memo?.lastModified ?? .zero }
  lazy var content: String = {
    return title + emptyParagraph + body
  }()
  
  func configure(with memo: Memo) {
    self.memo = memo
  }
}
