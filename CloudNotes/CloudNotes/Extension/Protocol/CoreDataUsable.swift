//
//  Protocol.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/14.
//

import UIKit
import CoreData

protocol CoreDataUsable {
    func fetchCoreDataItems(_ context: NSManagedObjectContext, _ tableview: UITableView)
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
}
