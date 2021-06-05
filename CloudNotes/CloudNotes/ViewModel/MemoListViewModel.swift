//
//  TableViewModel.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import Foundation

class MemoListViewModel {
  private var memoServiceAdapter = MemoProvider()
  private lazy var memos: [Memo]? = {
    do {
      let memos = try memoServiceAdapter.getMockData()
      return memos
    } catch {
      return nil
    }
  }()
  
  private lazy var memoViewModels: [MemoViewModel]? = {
    var memoViewModels: [MemoViewModel] = []
    guard let memos = memos else {
      return nil
    }
    let dateFormatter: DateFormatter = DateFormatter()

    for memo in memos {
      let date = Date(timeIntervalSince1970: TimeInterval(memo.lastModified))
      dateFormatter.locale = Locale(identifier: Locale.current.identifier)
      dateFormatter.setLocalizedDateFormatFromTemplate("yyyy. MM. d")
      let dateString = dateFormatter.string(from: date)
      memoViewModels.append(MemoViewModel(title: memo.title, date: dateString, content: memo.body))
    }
    
    return memoViewModels
  }()
  
  func addMemo(_ memo: Memo) {
    memos?.append(memo)
  }
  
  func getNumberOfMemo() -> Int {
    guard let memos = memos else {
      return .zero
    }
    return memos.count
  }
  
  func getMemoViewModel(for indexPath: IndexPath) -> MemoViewModel? {
    guard let memoViewModels = memoViewModels else {
      return nil
    }
    let memoViewModel = memoViewModels[indexPath.row]
    return memoViewModel
  }
  
  func getMemo(for indexPath: IndexPath) -> Memo? {
    guard let memos = memos else {
      return nil
    }
    
    return memos[indexPath.row]
  }
}
