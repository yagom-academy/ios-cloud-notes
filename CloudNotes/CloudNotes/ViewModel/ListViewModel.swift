//
//  ListViewModel.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import Foundation

class ListViewModel {
  private let memoInfoList: [MemoInfo] = [
    MemoInfo(title: "Title 1", date: "2021.06.02"),
    MemoInfo(title: "Title 2", date: "2021.06.03"),
    MemoInfo(title: "Title 3", date: "2021.06.04"),
    MemoInfo(title: "Title 4", date: "2021.06.05"),
    MemoInfo(title: "Title 5", date: "2021.06.06"),
    MemoInfo(title: "Title 6", date: "2021.06.07"),
    MemoInfo(title: "Title 7", date: "2021.06.08"),
    MemoInfo(title: "Title 8", date: "2021.06.09"),
    MemoInfo(title: "Title 9", date: "2021.06.10"),
    MemoInfo(title: "Title 10", date: "2021.06.11")
  ]
  
  var numOfMemoInfoList: Int {
    return memoInfoList.count
  }
  
  func memoInfo(at index: Int) -> MemoInfo {
    return memoInfoList[index]
  }
}
