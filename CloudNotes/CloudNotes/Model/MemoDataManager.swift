//
//  MemoDataManager.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/12.
//

import UIKit
import CoreData

class MemoDataManager {
  static let shared = MemoDataManager()
  
  func createMemo(completion: @escaping () -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let context = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "MemoInfo", in: context)
    if let entity = entity {
      let memo = NSManagedObject(entity: entity, insertInto: context)
      setMemoValue(set: memo,
                   title: MemoInfo.defaultTitle,
                   body: MemoInfo.defaultBody) {
        completion()
      }
      
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func updateMemo(lastModifiedDate: Double, titleToReplace: String, bodyToReplace: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let context = appDelegate.persistentContainer.viewContext
    
    // MARK: 수정을 fetchRequest.predicate 방식으로 진행해도 되는가..?
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MemoInfo")
    fetchRequest.predicate = NSPredicate(format: "lastModified = %lf", lastModifiedDate)
    do {
      let managedObject = try context.fetch(fetchRequest)
      guard let objectForUpdate = managedObject[0] as? NSManagedObject else {
        return
      }
      setMemoValue(set: objectForUpdate,
                   title: titleToReplace,
                   body: bodyToReplace) {}
      
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func setMemoValue(set memo: NSManagedObject,
                            title: String,
                            body: String,
                            completion: @escaping () -> Void) {
    let currentDate = Date()
    let lastModified = DateConvertor().dateToNumber(date: currentDate)
    memo.setValue(lastModified, forKey: "lastModified")
    memo.setValue(title, forKey: "title")
    memo.setValue(body, forKey: "body")
    
    completion()
  }
}
