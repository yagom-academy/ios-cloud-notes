//
//  Protocol.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/14.
//

import UIKit
import CoreData

//MARK:- Provide Method related to CoreData saving, fetching, deleting
protocol CoreDataUsable {
    func fetchCoreDataItems(_ context: NSManagedObjectContext, _ tableview: UITableView)
    func saveCoreData(_ context: NSManagedObjectContext)
    func deleteCoreData(_ context: NSManagedObjectContext, _ deletedObject: NSManagedObject)
}

extension CoreDataUsable {
    func fetchCoreDataItems(_ context: NSManagedObjectContext, _ tableview: UITableView) {
        do {
            MemoDataManager.memos = try context.fetch(Memo.fetchRequest())
            DispatchQueue.main.async {
                tableview.reloadData()
            }
        } catch {
            print(CoreDataError.fetchError.errorDescription)
        }
    }
    
    func saveCoreData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(CoreDataError.saveError.errorDescription)
        }
    }
    
    func deleteCoreData(_ context: NSManagedObjectContext, _ deletedObject: NSManagedObject) {
        context.delete(deletedObject)
    }
    
    func deleteSaveFetchData(_ context: NSManagedObjectContext, _ deletedObject: Memo, _ tableView: UITableView) {
        deleteCoreData(context, deletedObject)
        saveCoreData(context)
        fetchCoreDataItems(context, tableView)
    }
}
