//
//  ListViewModel.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import UIKit
import CoreData

final class ListViewModel {
  private var memoInfoList: [MemoInfo] = []
  
  init() {
    setMemoInfoList()
  }
  
  var numOfMemoInfoList: Int {
    return memoInfoList.count
  }
  
  var sortedMemoInfoList: [MemoInfo] {
    let sortedList = memoInfoList.sorted { prev, next in
      return prev.lastModified > next.lastModified
    }
    
    return sortedList
  }
  
  func setMemoInfoList() {
    do {
      self.memoInfoList = try MemoDataManager.shared.memoInfoList()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func memoInfo(at index: Int) -> MemoInfo {
    return sortedMemoInfoList[index]
  }
}
