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
  
  func setMemoInfoList() {
    do {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        throw SetMemoInfoListError.FailedToAccessAppDelegate
      }
      let context = appDelegate.persistentContainer.viewContext
      
      guard let infoList = try context.fetch(MemoInfo.fetchRequest()) as? [MemoInfo] else {
        throw SetMemoInfoListError.FailedToGetNSManagedObjectContext
      }
      self.memoInfoList = infoList
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func memoInfo(at index: Int) -> MemoInfo {
    return memoInfoList[index]
  }
}
