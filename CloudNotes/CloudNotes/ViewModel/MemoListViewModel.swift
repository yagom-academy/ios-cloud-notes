//
//  TableViewModel.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation

final class MemoListViewModel {
  private var memoServiceAdapter = MemoProvider.shared
  
  var count: Int {
    guard let memos = memoServiceAdapter.memos else { return .zero }
    return memos.count
  }
  
  func getMemoListCellModel(for indexPath: IndexPath) -> MemoListCellModel? {
    guard let memo = memoServiceAdapter.memos?[indexPath.row] else { return nil }
    let dateString = convertDateFormat(memo.lastModified)
    let viewModel = MemoListCellModel(title: memo.title, date: dateString, content: memo.body)
    return viewModel
  }
  
  func getMemo(for indexPath: IndexPath) -> Memo? {
    guard let memos = memoServiceAdapter.memos else { return nil }
    return memos[indexPath.row]
  }
  
  private func convertDateFormat(_ date: Date?) -> String? {
    guard let date = date else { return nil }
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: Locale.current.identifier)
    dateFormatter.setLocalizedDateFormatFromTemplate("yyyy. MM. d")
    return dateFormatter.string(from: date)
  }
}
