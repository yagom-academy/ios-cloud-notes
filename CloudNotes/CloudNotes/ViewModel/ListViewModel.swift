//
//  ListViewModel.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import Foundation

class ListViewModel {
  private let memoInfoList: [MemoInfo] = [
    MemoInfo(title: "Title 1", date: "2021.06.02", memo: "testmemo"),
    MemoInfo(title: "Title 2", date: "2021.06.03", memo: "testmemomemo"),
    MemoInfo(title: "Title 3", date: "2021.06.04", memo: "testmemomemomemo"),
    MemoInfo(title: "Title 4", date: "2021.06.05", memo: "testmemo"),
    MemoInfo(title: "Title 5", date: "2021.06.06", memo: "testmemomemo"),
    MemoInfo(title: "Title 6", date: "2021.06.07", memo: "testmemomemomemo"),
    MemoInfo(title: "Title 7", date: "2021.06.08", memo: "testmemo"),
    MemoInfo(title: "Title 8", date: "2021.06.09", memo: "testmemo"),
    MemoInfo(title: "Title 9", date: "2021.06.10", memo: "test"),
    MemoInfo(title: "Title 10", date: "2021.06.11", memo: "test")
  ]
  
  var numOfMemoInfoList: Int {
    return memoInfoList.count
  }
  
  func memoInfo(at index: Int) -> MemoInfo {
    return memoInfoList[index]
  }
}
