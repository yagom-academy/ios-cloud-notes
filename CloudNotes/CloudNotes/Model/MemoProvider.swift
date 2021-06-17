//
//  MemoItemProvider.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/02.
//

import UIKit
import CoreData

final class MemoProvider {
  private let currentViewController = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first?.rootViewController
  
  // MARK: - For Single Tone
  static let shared: MemoProvider = MemoProvider()
  private init() { }
    
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "CloudNotes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        let alert = UIAlertController(title: "Core Data Store Container", message: error.description, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.currentViewController?.present(alert, animated: true, completion: nil)
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
        let alert = UIAlertController(title: "Core Data Save Error", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.currentViewController?.present(alert, animated: true, completion: nil)
      }
    }
  }
  
  // MARK: - Manage Memo Data
  private var memo: [Memo]?

  func createMemoData() {
    
  }
  
  func fetchMemoData() {
    
  }
  
  func updateMemoData(indexPath: IndexPath, title: String, body: String) {
    
  }
  
  func deleteMemoData(indexPath: IndexPath) {
    
  }
}
