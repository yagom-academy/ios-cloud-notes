//
//  ListViewModel.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import UIKit
import CoreData

class ListViewModel {
  private var memoInfoList: [MemoInfo] = []
  
  init() {
    setMemoInfoDummy()
    setMemoInfoList()
  }
  
  var numOfMemoInfoList: Int {
    return memoInfoList.count
  }
  
  private func setMemoInfoList() {
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
  
  private func setMemoInfoDummy() {
    let memoInfo = MemoInfoDummy(title: "test title",
                                 lastModified: 1608651333,
                                 body: "it is test's body.estes.ts.ets.etestsetsetes")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "MemoInfo", in: context)
    
    if let entity = entity {
      let memo = NSManagedObject(entity: entity, insertInto: context)
      memo.setValue(memoInfo.title, forKey: "title")
      memo.setValue(memoInfo.lastModified, forKey: "lastModified")
      memo.setValue(memoInfo.body, forKey: "body")
      
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func memoInfo(at index: Int) -> MemoInfo {
    return memoInfoList[index]
  }
}
