//
//  DataManager.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/09.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var memoList = [Memo]()
    
    func fetchData() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print("데이터 불러오기 실패")
        }
    }
    
    func createData() {
        let newMemo = Memo(context: mainContext)

        newMemo.title = "새로운 메모"
        newMemo.body = "추가 텍스트 없음"
        newMemo.lastModifiedDate = Date()
        
        saveContext()
        fetchData()
    }
    
    func deleteData(index: Int) {
        let memoToRemove = memoList[index]
        mainContext.delete(memoToRemove)
        saveContext()
        fetchData()
    }
    
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
    
}
