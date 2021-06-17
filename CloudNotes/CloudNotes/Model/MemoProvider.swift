//
//  MemoItemProvider.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit
import CoreData

final class MemoProvider {
  // MARK: - For Single Tone
  static let shared: MemoProvider = MemoProvider()
  private init() { }
    
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "CloudNotes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  // MARK: - Manage Memo Data
  private var memo: [Memo]?

  
  func getMockData() throws -> [Memo]? {
    
    return nil
  }
}
