//
//  ListViewModel.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import Foundation

final class ListViewModel {
  private var memoInfoList: [MemoInfo] = []
  
  init() {
    do {
      // 임시 Data
      guard let filePath = Bundle.main.path(forResource: "sample", ofType: "json") else {
        throw DecodingError.PathNotFound
      }
      guard let data = try String(contentsOfFile: filePath).data(using: .utf8) else {
        throw DecodingError.DataConversionFailed
      }
      memoInfoList = try JSONDecoder().decode([MemoInfo].self, from: data)
    } catch {
      print(error)
    }
  }
  
  var numOfMemoInfoList: Int {
    return memoInfoList.count
  }
  
  func memoInfo(at index: Int) -> MemoInfo {
    return memoInfoList[index]
  }
}
